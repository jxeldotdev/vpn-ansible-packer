#!/usr/bin/env python3

import boto3
from botocore.exceptions import ClientError
import os
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def get_secret():
    try:
        session = boto3.Session(
            aws_access_key_id=os.environ["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=os.environ["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=os.environ["AWS_SESSION_TOKEN"]
        )
        client = session.client(
            service_name='secretsmanager',
            region_name='ap-southeast-2'
        )
    except ClientError as ex:
        logger.critical(msg="Failed to setup AWS Session", exc_info=ex)

    try:
        secret_name = os.environ["VAULT_AWS_SECRET_NAME"]
    except KeyError as ex:
        logger.critical(msg="Failed to get secret name from environment variables", exc_info=ex)
        exit(1)

    # Not exactly ideal that errors contain ARNs but it is OK as GitHub Actions hides secrets in the log.
    # This is only an issue as it is a public repository.
    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        logger.error(e.response['Error'])
        if e.response['Error']['Code'] == 'ResourceNotFoundException':
            logger.error("The requested secret was not found", e.response['Error'])
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            logger.error("The request was invalid due to:", e.response['Error'])
        elif e.response['Error']['Code'] == 'AccessDeniedException':
            logger.error("The request failed due to insufficient permissions", e.response['Error'])
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            logger.error("The request had invalid params:", e.response['Error'])
        elif e.response['Error']['Code'] == 'DecryptionFailure':
            logger.error("The requested secret can't be decrypted using the provided KMS key:", e.response['Error'])
        elif e.response['Error']['Code'] == 'InternalServiceError':
            logger.error("An error occurred on service side:", e.response['Error'])
        
        exit(1)

    else:
        # Secrets Manager decrypts the secret value using the associated KMS CMK
        # Depending on whether the secret was a string or binary, only one of these fields will be populated
        if 'SecretString' in get_secret_value_response:
            text_secret_data = get_secret_value_response['SecretString']
        else:
            binary_secret_data = get_secret_value_response['SecretBinary']
        return text_secret_data

    
if __name__ == "__main__":
    print(get_secret())
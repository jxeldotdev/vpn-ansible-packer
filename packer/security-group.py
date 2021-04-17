# Tool to create and delete temporary security groups to be used by packer.


import sys
import ipaddress
import urllib3
import boto3

from botocore.exceptions import ClientError
from time import strftime

client = boto3.client('ec2')

def get_public_ip() -> str:
    """
    Return IP of current machine in CIDR notation, or 0.0.0.0/0 if unable to get IP
    """

    http = urllib3.PoolManager()

    try:
        publicIp = http.request('GET','http://ipinfo.io/ip')
        publicIp = publicIp.data
        try:
            ipaddress.ip_address(publicIp)
        except ValueError as e:
            # IP isn't valid
            print("Error occured while trying to validate public IP")
            print(e)
            return "0.0.0.0/0"

    except urllib3.exceptions.HTTPError as e:
        print("Error occured while trying to get public IP")
        print(e)
    
    return "{}/32".format(publicIp)


def get_default_vpc(client) -> str:
    """
    Get default VPC in AWS Account
    """
    vpcs = client.describe_vpcs(
        Filters=[
            {
                'Name': 'isDefault',
                'Values': ['true'],
            },
        ],
    )

    vpcId = vpcs['Vpcs'][0].VpcID

    return vpcId


def create(vpcId, additionalPort=2048):
    """
    Create temporary security group for Packer and authorize ingress SSH
    """
    
    sgName = "packer-temporary-{}".format(strftime("%D-%H-%M"))
    try:
        
        resp = client.create_security_group(
            GroupName=sgName,
            Description="Temporary security group for AMI Build",
            VpcId=vpcId
        )
        sgId = resp['GroupId']
        print("Created security group {} successfully".format(securityGroupId))
    except ClientError as e:
        print("Error occurred while trying to create security group")
        print(e)
    
    ip = get_public_ip()

    permissions=[
        {
            'IpProtocol': 'tcp',
            'FromPort': 22,
            'ToPort': 22,
            'IP': [{'CidrIp': ip}]
        },
        {
            'IpProtocol': 'tcp',
            'FromPort': additionalPort,
            'ToPort': additionalPort,
            'IP': [{'CidrIp': ip}],
        },
    ]

    tags = [
        {
            'Key': 'Class',
            'Value': 'packer'
        }
    ]

    try:
        rules = client.authorize_security_group_ingress(
            GroupId=sgId,
            IpPermissions=permissions
        )
        print("Added security group rules to {}".format(sgId))
    except ClientError as e:
        print("Error occured while trying to set security group rules on {}".format(sgId))
        print(e)
    
    return sgId


def delete(sgId=None):
    """
    Delete temporary AWS security group for packer
    """

    try:
        client.describe_security_groups(GroupIds=[sgId])
    except ClientError as e:
        print("Security group {} does not appear to exist".format(sgId))
        print(e)
        print("Searching for security group with tag")
        try:
            sg = client.describe_security_groups(
                Filters=[
                    {
                        'Name': 'tag:Class',
                        'Values': ['packer']
                    },
                ],
            )
            sgId=sg['SecurityGroups'][0]['GroupId']
        except ClientError as e:
            print("Failed to ")
        
    try:
        client.delete_security_group(GroupId=sgId)
    except ClientError as e:
        print("Error occured while trying to delete security group")

    return True


def main():
    try:
        if sys.argv[1] == "delete".lower():
            print("Creating security g")
            try:
                param = sys.argv[2]
            except IndexError:
                delete()
            else:   
                delete(param)
        elif sys.argv[1] == "create":
            print("Creating security group for packer")
            create()
    except IndexError:
        print("Utility to create TEMPORARY security groups for Packer with correct ports open for SSH")
        print("USAGE:")
        print("{} create - Creates a security group for Packer".format(sys.argv[0]))
        print("{} delete [ID] - Deletes temporary security group.If ID is not passed, the script will try to find the security group using tags.""".format(sys.argv[0]))


if __name__ == "__main__":
    main()

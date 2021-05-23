#!/bin/bash

if ssh-add -L | grep -i 'no identities' 1>&/dev/null
then 
    echo "SSH Agent is not setup. Configure it then re-run this script" 1>&2
    exit 1
fi

case "$@" in 
    pritunl-ami)
        if [ -z $VAULT_PW_FILE_PATH ];
        then
            VAULT_PW_FILE_PATH="$PWD/ansible/vault-password"
            echo 1>&2 "VAULT_PW_FILE_PATH is not set, setting to $VAULT_PW_FILE_PATH"
        fi

        if [ -z $VAULT_PATH ];
        then
            VAULT_PATH="$PWD/ansible/vault.yml"
            echo 1>&2 "VAULT_PATH is not set, setting to $VAULT_PATH"
        fi
        if [ -z $SSH_USER ];
        then
            SSH_USER="jfreeman"
            echo 1>&2 "SSH_USER is not set, setting to $SSH_USER"
        fi

        packer build \
        -var ssh_username="$SSH_USER" \
        -var vault_pw_file_path="$VAULT_PW_FILE_PATH" \
        -var vault_path="$VAULT_PATH" \
        packer/packer-rhel8-pritunl.pkr.hcl
        ;;
    
    base-ami)
        set -x 
        if [ -z $VAULT_PW_FILE_PATH ];
        then
            VAULT_PW_FILE_PATH="$PWD/ansible/vault-password"
            echo 1>&2 "VAULT_PW_FILE_PATH is not set, setting to $VAULT_PW_FILE_PATH"
        fi

        if [ -z $VAULT_PATH ];
        then
            VAULT_PATH="$PWD/ansible/vault.yml"
            echo 1>&2 "VAULT_PATH is not set, setting to $VAULT_PATH"
        fi

        packer build \
        -var vault_pw_file_path="$VAULT_PW_FILE_PATH" \
        -var vault_path="$VAULT_PATH" \
        packer/packer-rhel8-secure.pkr.hcl 
        ;;
    *)
        echo "Unknown command specified - command was $@" 1>&2
        echo "Available commands: base-ami, pritunl-ami" 1>&2
        exit 127
        ;;
esac
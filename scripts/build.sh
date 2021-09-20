#!/bin/bash

if ssh-add -L | grep -i 'no identities' 1>&/dev/null
then 
    echo "SSH Agent is not setup. Configure it then re-run this script" 1>&2
    exit 1
fi

function check_deps() {
    if [ -z $VAULT_PW_FILE_PATH ];
        then
            VAULT_PW_FILE_PATH="$PWD/ansible/vault-password"
            echo "VAULT_PW_FILE_PATH is not set, setting to $VAULT_PW_FILE_PATH" 1>&2
    fi

    if [ -z $VAULT_PATH ];
    then
        VAULT_PATH="$PWD/ansible/vault.yml"
        echo "VAULT_PATH is not set, setting to $VAULT_PATH" 1>&2
    fi
    if [ -z $SSH_USER ];
    then
        SSH_USER="jfreeman"
        echo  "SSH_USER is not set, setting to $SSH_USER" 1>&2
    fi

    if ! which ansible-playbook &>/dev/null
    then
        echo "Unable to execute ansible-playbook. Check if it's installed, or if you are in the correct virtual environment?" 1>&2
        exit 1
    fi
    
    # Check AWS CLI & Credentials are configured properly
    if which aws &>/dev/null;
    then
        if ! aws sts get-caller-identity &>/dev/null;
        then
            echo "Unable to check AWS credentials. Exiting.." 1>&2
            aws sts get-caller-identity
            exit 1
        fi
    else
        echo "AWS CLI is not installed or is incorrectly configured." 1>&2
        which aws
        aws
        exit 1
    fi
        
    
}

case "$@" in 
    pritunl-ami)
        check_deps

        packer build \
        -var ssh_username="$SSH_USER" \
        -var vault_pw_file_path="$VAULT_PW_FILE_PATH" \
        -var vault_path="$VAULT_PATH" \
        packer/packer-rhel8-pritunl.pkr.hcl 2>&1 | tee build-log
        grep -B 5 -A 5 -ni "show password" build-log
        ;;
    
    base-ami)
        check_deps

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
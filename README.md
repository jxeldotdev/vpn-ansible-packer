# vpn-ansible-packer



[Ansible](https://docs.ansible.com) Roles and [Packer](https://www.packer.io) configuration to build two AWS AMIs:
* Base configuration (RHEL 8 Activated, Monitoring configured (TBC), utility packages installed, security etc.)
* [Pritunl](https://pritunl.com/) VPN Installed including its dependencies. This uses the AMI above.

This repository also contains a Python script located in `helpers/securitygroup.py` to manage **temporary** AWS Security Groups used by Packer.

This is used in the infrastructure for my todo app project. View the following repositories and project for more information:
* [todoapp-frontend](https://github.com/jxeldotdev/todoapp-frontend)
* [todoapp-backend](https://github.com/jxeldotdev/todoapp-backend)
* [todoapp-infrastructure](https://github.com/jxeldotdev/todoapp-infrastructure)

## Usage

## Create an Ansible Vault file

Create an ansible vault file with the following variables:
* vault_ansible_user_password
* vault_redhat_activation_key
* vault_ansible_user_password
* ansible_become_password

### Install dependencies

```
pip install pipenv

# Installs ansible 
pipenv install
```

Please ensure that you have access to the RHEL AMIs.

### Building base AMI

```
# Verify that you can access an AWS account
aws sts get-caller-identity

./build.sh base-ami
```

### Building VPN AMI

```
# Verify that you can access an AWS account
aws sts get-caller-identity

./build.sh pritunl-ami
```

### Terraform configuration


# vpn-ansible-packer



[Ansible](https://docs.ansible.com) roles and[Packer](https://www.packer.io) config to build two AWS AMIs:
* Base configuration (RHEL 8 Activated, Monitoring configured (TBC), utility packages installed, security etc.)
* [Pritunl](https://pritunl.com/) VPN Installed including its dependencies. This uses the AMI above.

This repository also contains a terraform module used for deploying it.

This is used in the infrastructure for my todo app project. View the following repositories and project for more information:
* [todoapp-frontend](https://github.com/jxeldotdev/todoapp-frontend)
* [todoapp-backend](https://github.com/jxeldotdev/todoapp-backend)
* [todoapp-infrastructure](https://github.com/jxeldotdev/todoapp-infrastructure)

## Getting started

## Create an Ansible Vault file

Create an ansible vault file with the following variables:
* vault_ansible_user_password
* vault_redhat_activation_key
* vault_ansible_user_password
* ansible_become_password
* root_password

### Install dependencies

Make sure you have the following tools installed:
* [Packer](https://www.packer.io/downloads)
* [Terraform (Optional, only required for deploying to AWS)](https://www.terraform.io/downloads.html)
* [Ansible](https://www.ansible.coms)

If you don't have ansible installed, you can install it by running the following below:

```
# use pipenv to install ansible or pip to install ansible
(which pipenv && pipenv install) || pip install --user ansible
```

Please ensure that you have access to the RHEL AMIs.

### Building base AMI

```
# Verify that you can access an AWS account, and you're in the right account.
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


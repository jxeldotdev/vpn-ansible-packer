# vpn-ansible-packer



[Ansible](https://docs.ansible.com) Roles and [Packer](https://www.packer.io) configuration to build two AWS AMIs:
* Base configuration (RHEL 8 Activated, Monitoring configured, utility packages installed, security etc.)
* [Pritunl](https://pritunl.com/) VPN Installed including its dependencies. This uses the AMI above.

This repository also contains a Python script located in `helpers/securitygroup.py` to manage **temporary** AWS Security Groups used by Packer.

This is used in the infrastructure for my todo app project. View the following repositories and project for more information:
* [todoapp-frontend](https://github.com/jxeldotdev/todoapp-frontend)
* [todoapp-backend](https://github.com/jxeldotdev/todoapp-backend)
* [todoapp-infrastructure](https://github.com/jxeldotdev/todoapp-infrastructure)

## Usage
---

### Install dependencies

```
pip install pipenv
pipenv install
```

### Building base AMI

```
# Start shell in python virtual environment
pipenv shell

# Verify that you can access an AWS account
aws sts get-caller-identity

make base-ami
```

### Building VPN AMI

```
# Start shell in python virtual environment
pipenv shell

# Verify that you can access an AWS account
aws sts get-caller-identity

make pritunl-ami
```
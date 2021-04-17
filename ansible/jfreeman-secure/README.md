jfreeman-secure
=========

Role to 

* Install utilities
* Create a user for personal access 
* Register RedHat Subscription
* Configure SSHD 
  * Set to non-default port
  * Disable root login
  * Disable password authentication



Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

#### sshd_port

Port which SSHD will be updated to listen on.

#### github_keys

HTTP URL to a GitHub user's keys, e.g `https://github.com/jxeldotdev.keys`

#### ansible_user_name

Name of ansible user to create

#### running_locally

Whether the role is running locally or not. If the role is running locally it will not try to access the host on different SSH ports.

### Vault variables

#### ansible_user_password

encrypted password for ansible user.

This is set to `{{ vault_ansible_user_password }}`

#### redhat_org_id

RedHat Organisation ID

This is set to `{{ vault_redhat_org_id }}`

#### redhat_activation_key

RedHat Activation Key 

This is set to `{{ vault_redhat_activation_key }}`


Dependencies
------------

* community.general
* ansible.posix

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

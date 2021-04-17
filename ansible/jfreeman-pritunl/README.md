jfreeman-pritunl
=========

Install and configure Pritunl on RHEL8 / CentOS 8.

Requirements
------------



Role Variables
--------------

#### pritunl_web_port
Default: 8080

Port for Pritunl Web UI.

#### vpn_port
Default: 6823

Port that Pritunl VPN Server will run on.
  
#### configure_mongodb_backups
Default: False

This variable defines whether to setup automated backups of mongodb to an S3 Bucket.


It is not reccomended to use this if you are running on public cloud as you can use the cloud provider's backup service, e.g EBS Snapshots on AWS.

Dependencies
------------

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

.PHONY:
base-ami:
	pipenv run python ./packer/helpers.py create
	packer build packer/packer-rhel8-secure.pkr.hcl
	pipenv run python ./packer/helpers.py delete

.PHONY:
pritunl-ami:
	pipenv run python ./helpers/securitygroup.py create
	packer build packer/packer-rhel8-pritunl.pkr.hcl
	pipenv run python ./helpers/securitygroup.py delete


.PHONY:
test-secure-role:
	exit 1


.PHONY:
test-pritunl-role:
	exit 1
base-ami: securitygroup
	packer build -var sg_id=$(shell jq '.GroupId' .group.json) packer/packer-rhel8-secure.pkr.hcl
	$(MAKE) clean

pritunl-ami:
	packer build packer/packer-rhel8-pritunl.pkr.hcl

securitygroup:
	pipenv run python ./helpers/securitygroup.py create

clean:
	pipenv run python ./helpers/securitygroup.py delete
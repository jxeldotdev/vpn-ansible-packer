base-ami: 
	packer build \
	-var vault_pw_file_path=$(PWD)/ansible/vault-password \
	-var vault_path=$(PWD)/ansible/vault.yml \
	packer/packer-rhel8-secure.pkr.hcl 

pritunl-ami:
	packer build \
	-var ssh_username="jfreeman" \
	-var ssh_port=2048 \
	packer/packer-rhel8-pritunl.pkr.hcl
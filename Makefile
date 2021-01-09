.PHONY: plan apply destroy provision provision-users provision-requirements provision-security minecraft-install minecraft

VERBOSITY 	?= -v

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy


provision-users:
	cd ansible; ansible-playbook --private-key=../ssh_keys/id_hcloud_minecraft minecraft.yml --tags provision-requirements $(VERBOSITY)


provision-requirements:
	cd ansible; ansible-playbook --private-key=../ssh_keys/id_hcloud_minecraft minecraft.yml --tags provision-users $(VERBOSITY)


provision-security:
	cd ansible; ansible-playbook --private-key=../ssh_keys/id_hcloud_minecraft minecraft.yml --tags provision-security $(VERBOSITY)


provision:
	cd ansible; ansible-playbook --private-key=../ssh_keys/id_hcloud_minecraft minecraft.yml --tags provision $(VERBOSITY)


minecraft-install:
	cd ansible; ansible-playbook --private-key=../ssh_keys/id_hcloud_minecraft minecraft.yml --tags minecraft-install $(VERBOSITY)


minecraft: 
	cd ansible; ansible-playbook --private-key=../ssh_keys/id_hcloud_minecraft minecraft.yml --tags minecraft $(VERBOSITY)
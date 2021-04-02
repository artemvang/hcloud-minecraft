.PHONY: plan apply destroy provision provision-users provision-requirements provision-security minecraft-install minecraft

VERBOSITY 	?= -v
SERVER_ID   := $(shell terraform output server_id)
INVENTORY   := $(subst $\",,"inventory-$(SERVER_ID)")

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy


provision-users:
	cd ansible; ansible-playbook -i $(INVENTORY) minecraft.yml --tags provision-requirements $(VERBOSITY)


provision-requirements:
	cd ansible; ansible-playbook -i $(INVENTORY) minecraft.yml --tags provision-users $(VERBOSITY)


provision-security:
	cd ansible; ansible-playbook -i $(INVENTORY) minecraft.yml --tags provision-security $(VERBOSITY)


provision:
	cd ansible; ansible-playbook -i $(INVENTORY) minecraft.yml --tags provision $(VERBOSITY)


minecraft-install:
	cd ansible; ansible-playbook -i $(INVENTORY) minecraft.yml --tags minecraft-install $(VERBOSITY)


minecraft: 
	cd ansible; ansible-playbook -i $(INVENTORY) minecraft.yml --tags minecraft $(VERBOSITY)

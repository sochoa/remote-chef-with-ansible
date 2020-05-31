# vim: set ts=2:

.DEFAULT_GOAL := default

destroy:
	vagrant destroy -f

create:
	vagrant up

ping:
	ansible -m ping -i hosts all

default: destroy create ping

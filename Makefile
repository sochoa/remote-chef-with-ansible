# vim: set ts=2:

.DEFAULT_GOAL := default

destroy:
	vagrant destroy -f

default:
	vagrant up
	ansible -m ping -i hosts all

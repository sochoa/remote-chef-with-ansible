# vim: set ts=2:

.DEFAULT_GOAL := default
TS := $(shell date +"%Y%m%d%H%M%S")

vagrant-destroy:
	vagrant destroy -f

vagrant-create:
	vagrant up

ansible-ping:
	ansible -m ping -i ansible/hosts all

ansible-deploy-chef:
	ansible-playbook -i ansible/hosts ansible/plays/remote-chef.yml

chef-clean:
	( cd chef; rm -rf ./chef-repo/* )
	( cd chef; rm -f chef-repo.tar.bz2 )

chef-package: chef-clean
	( cd chef; berks vendor ./chef-repo/cookbooks )
	( cd chef; cp -r roles ./chef-repo/ )
	( cd chef; tar -cvjSf chef-repo.tar.bz2 chef-repo )

ansible-run-chef-solo:
	ansible-playbook -i ansible/hosts -e 'chef_role=my-service' ansible/plays/chef-role.yml

test-my-service:
	curl 

default:              \
	vagrant-destroy     \
	vagrant-create      \
	ansible-ping        \
	chef-package        \
	ansible-deploy-chef \
	ansible-run-chef-solo

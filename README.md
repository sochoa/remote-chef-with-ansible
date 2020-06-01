Remote Chef with Ansible
========================

## Why Chef?

Chef is pretty cool for software engineers to be able 
to use for configuration management while still leveraging
their software engineering expertise.  Others like cfengine, 
puppet, SaltStack, and others may be capable tools -- but 
in my experience Chef has been the most effective and versatile 
tool for enforcing configuration on linux-based systems.

## Why Ansible?

Well, there are a lot of tools that could do the same thing.  

Ansible is just the one that I chose.

Others have used Capistrano for orchestration in similar 
applications.

## Why Ansible and Chef?

Well, because each is good at the one thing they were
meant for.  Chef for configuration management and 
Ansible for orchestration.

## So what does this codebase do?

The default target of the Makefile shows the full workflow:

### Vagrant Destroy/Create

This step is just for this project.  You're probably not going to be managing vagrant boxes with this complicated of a setup.

The one part of this step that's fairly important is the creation of the ansible host inventory file `ansible/hosts`:

```
[vagrant]
my-service
```

And, in this case the `vagrant ssh-config` portion generates the ssh-config that ansible can use.  See `ansible.cfg` for how to configure which ssh config to use.

### Ansible Ping

Ensure that the remote host is reachable.

```
ansible -m ping -i ansible/hosts all
```

### Chef Package

This is an important step.  It creates the chef-repo artifact.  The chef repo is going to have all the "Chef" things that you need to converge your target system.  That should include data bags, environments, roles, and cookbooks as needed.

### Ansible Deploy Chef

* Copies up the chef-repo tarball
* Unpacks it
* Symlinks `/var/chef-repo` -> `/var/chef-repo-$TIMESTAMP`
* Installs Chef 
* Creates /etc/chef/solo.rb

### Ansible Run Chef Solo

Applies the chef role to the instance

## So why do it this way? 

* No Chef server required
* Still versions the chef-repo
* Does not use Chef Delivery -- which has a less than steller reputation.
* Its a relatively decent way to manage infrastructure with code

## What are the trade-offs?

* Slow propegation of changes
* Assumes single operator and not automated execution
* Not using separate source for secrets can be a potential security issue when encrypted data bags are left on-disk
* Operators may not understand Ansible, Chef, and to some degree Make
* Assumes that infrastructure hosts are "pets and not cattle" -- meaning that hosts managed with this method are assumed to be stateful pets (e.g. databases or filestores) that can't just be replaced easily versus cattle that are mostly (if not completely) stateless and can be replaced easily (e.g. webservers).

# Summary

I really like this method for when systems are old, brittle, and must be maintained to stay up as long as possible.   Sadly, this is a common state of affairs in software-as-a-service and infrastructure-as-a-service shops.  I hope this overview and associated codebase makes life easier for you in some way.  Drop me a line if it does.

# vim: set ft=ruby:

svc = "my-service"
host_default_iface = `/sbin/ip route | awk '/^default/{print $5}' | head -n1`.strip

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network :public_network, bridge: host_default_iface
  config.vm.provider :virtualbox do |vm|
    vm.name = svc
  end
  config.vm.define svc do |vm|
    vm.trigger.after [:up] do |trigger|
      trigger.info = "Generating #{svc} ssh-config"
      trigger.run = {
        path: "scripts/gen-ssh-config.sh", 
        args: svc,
      }
    end
  end
end


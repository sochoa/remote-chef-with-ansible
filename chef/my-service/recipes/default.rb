#
# Cookbook:: my-service
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
file '/tmp/chef-node.json' do 
  content node.to_json
end

# https://github.com/sous-chefs/nginx
nginx_install 'epel' do
  worker_processes 'auto'
  port 80
  default_site_enabled false
end

# https://docs.chef.io/resources/systemd_unit/
systemd_unit 'nginx' do
  action [:start, :enable]
end

# https://docs.chef.io/resources/template/
nginx_conf_variables = { web_root: "/var/www", index: "index.html"}
template '/etc/nginx/conf.d/my-service.conf' do 
  source 'site.erb'
  variables nginx_conf_variables
  notifies :restart, 'systemd_unit[nginx]', :immediately
end

# https://docs.chef.io/resources/file/
directory "/var/www" do 
  action :create
  notifies :create, 'file[/var/www/index.html]', :immediately
end

file "/var/www/index.html" do 
  content "Hello, My Service"
  action :nothing
end

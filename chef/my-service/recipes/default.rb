#
# Cookbook:: my-service
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# https://github.com/sous-chefs/nginx
nginx_install 'default' do
  worker_processes 'auto'
  port node['port']
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
end

# https://docs.chef.io/resources/file/
file "/var/www/index.html" do 
  content "Hello, My Service"
end

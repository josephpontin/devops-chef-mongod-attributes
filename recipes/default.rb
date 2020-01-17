#
# Cookbook:: mongod_cookbook
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# apt_repository 'mongodb' do
#   uri        'http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse'
#   components ['mongodb']
# end
#
# package 'mongodb'

# include_recipe "sc-mongodb::default"


bash 'mongo_get_source' do
  code <<-EOH
    # key needed to access repo
    wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

    # gets url of that source and adds to list
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

    # pulls from source
    # sudo apt-get update -y
    EOH
  end

# include_recipe 'apt'
apt_update

bash 'install_mongo' do
  code <<-EOH
    # installs
    sudo apt-get install -y mongodb-org
    EOH
  end

# package 'mongodb-org=3.2.20' do
#   action :install
# end


service 'mongod' do
  action [:start, :enable]
end

# link '/etc/mongod.conf' do
#   action :delete
# end

template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  variables bind_ip: node['mongod']['bind_ip']
  notifies :restart, 'service[mongod]'
end

# link '/lib/systemd/system/mongod.service' do
#   action :delete
# end

template '/lib/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  action :create
  notifies :restart, 'service[mongod]'
end

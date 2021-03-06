#
# Cookbook:: mongod_cookbook
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'mongod_cookbook::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    # it 'should install mongodb' do
    #   expect(chef_run).to install_package 'mongodb-org'
    # end

    it 'enables mongod service' do
      expect(chef_run).to enable_service 'mongod'
    end

    it 'start mongod service' do
      expect(chef_run).to start_service 'mongod'
    end

    it 'should create a mongod.conf template in /etc/mongod.conf' do
      expect(chef_run).to create_template('/etc/mongod.conf').with_variables(bind_ip: '0.0.0.0', listen_port: '27017')
    end

    it 'should create a mongod.service template in /lib/systemd/system/mongod.service' do
      expect(chef_run).to create_template '/lib/systemd/system/mongod.service'
    end



  end

  # context 'When all attributes are default, on CentOS 7' do
  #   # for a complete list of available platforms and versions see:
  #   # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
  #   platform 'centos', '7'
  #
  #   it 'converges successfully' do
  #     expect { chef_run }.to_not raise_error
  #   end
  # end
end

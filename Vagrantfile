# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'docker'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "postgres" do |postgres|
    postgres.vm.provider 'docker' do |d|
      d.image  = 'postgres'
      d.name   = 'login_postgres'
    end
  end

  config.vm.define "web" do |web|
    web.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 4096]
    end
    web.vm.provider 'docker' do |d|
      d.build_dir = '/apps/login'
      # d.build_args = ['-t barnabyalter/login']
      # d.image           = 'barnabyalter/login'
      d.name            = 'barnabyalter/login'
      d.create_args     = ['-i', '-t']
      d.cmd             = ['/bin/bash', '-l']
      d.remains_running = false
      d.ports           = ['3000:3000']

      d.link('login_postgres:postgres')
    end

    web.vm.synced_folder ".", "/apps/login", owner: 'wsops', group: 'wsops'
  end
end

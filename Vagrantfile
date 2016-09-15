# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


def vm_defaults(name, server)
  server.vm.network "private_network", type: "dhcp"
  server.vm.synced_folder ".", "/vagrant", type: "nfs"

  server.vm.provision 'shell' do |s|
    s.privileged = false
    s.path = "provision.sh"
  end

  server.vm.provider :virtualbox do |vb|
    vb.name = name
  end
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define 'build-linux-x86_64' do |server|
    server.vm.box = 'ubuntu/xenial64'
    server.vm.box_version = "20160830.0.0" # Newer versions had network issues
    vm_defaults("ruby-musl", server)
  end
end

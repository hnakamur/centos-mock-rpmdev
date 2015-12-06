# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.network "private_network", ip: "192.168.33.34"
  config.vm.provision "shell", privileged: false, path: "setup.sh"
  config.vm.synced_folder ".", "/home/vagrant/rpmbuild", type: "nfs"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end

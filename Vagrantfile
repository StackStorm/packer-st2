# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder '.', '/vagrant'

  # VirtualBox.
  # `vagrant up virtualbox --provider=virtualbox`
  config.vm.define "virtualbox" do |virtualbox|
    virtualbox.vm.hostname = "stackstorm-virtualbox"
    # TODO: Try to automatically find & use the latest box from the ./builds dir?
    virtualbox.vm.box = "file://builds/st2_v2.7.0-1523648841.box"
  end

end

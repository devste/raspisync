# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
	sudo apt-get autoremove -y chef puppet rpcbind
	# sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get install -y build-essential git unzip
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.ssh.forward_agent = true

	config.vm.define "raspisync-dev", primary: true do |vm|
                vm.vm.box = "ubuntu/trusty64"

		vm.vm.provider :virtualbox do |vb|
			vb.memory = 2048
			vb.cpus = 4
		end

		vm.vm.provision "shell", inline: $script
		vm.vm.synced_folder ".", "/home/vagrant/raspisync", create: true
	end

end

#Generic Vagrant File to deploy an OpenStack using an environment.yaml file
#Prepared by G. Tosi
#Version 1.0


# -*- mode: ruby -*-
# # vi: set ft=ruby :
 
# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"
#if not behind proxy comment these lines
#Vagrant.configure("2") do |config|
#  if Vagrant.has_plugin?("vagrant-proxyconf")
#    config.proxy.http     = "http://172.16.112.100:8080/"
#    config.proxy.https    = "http://172.16.112.100:8080/"
#    config.proxy.no_proxy = "localhost,127.0.0.1,192.168.56.56"
#  end
#end

# Require YAML module - Needed to parse YAML file
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('environment.yml')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 
  # Iterate through entries in YAML file
  servers.each do |servers|
    config.vm.define servers['name'] do |srv|
  
  #Fix issue with rsync on Windows
	srv.vm.synced_folder ".", "/home/vagrant/sync", type: "nfs"  
  
  # Setting Box URL
  if servers.has_key?('box_url')
          srv.vm.box_url = servers['box_url']
		end
  #Installing Operating System
    srv.vm.box = servers['box']
	
  #Setting VM hostname
	srv.vm.hostname = servers['name']
    
	#Configure network interfaces 
		if servers.has_key?('management_ip')
          srv.vm.network "public_network", ip: servers['management_ip'], adapter: servers['management_adapter']
		end
    
	#Setting forward port
	srv.vm.network "forwarded_port", guest: 80, host: 8080

#Set bootstrap script
	
			# default router
			srv.vm.provision "shell",
			run: "always",
			inline: "route add default gw 192.168.0.1"

		# delete default gw on eth0
			srv.vm.provision "shell",
			run: "always",
			inline: "eval `route -n | awk '{ if ($8 ==\"eth0\" && $2 != \"0.0.0.0\") print \"route del default gw \" $2; }'`"      

	
	if servers.has_key?('shell')
	  srv.vm.provision :shell, :path => servers['shell']
	end
	
    #Set VM CPU and memory
	srv.vm.provider :virtualbox do |vb|
        vb.memory = servers['memory']
        vb.cpus = servers['cpus']
    end
  end
end
end
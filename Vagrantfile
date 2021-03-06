# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "C:\\HashiCorp\\Vagrant\\Boxes\\precise64.box"
  #config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "192.168.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # config.vm.forward_port 80, 8080
  config.vm.forward_port 8000, 8888
  # buildbot by default uses port number 8010. So,to access it from windows you can use
  # URL http://localhost:8010 from your windows browser. Make sure that you start buildbot
  # master on port 9999
  config.vm.forward_port 9999, 8010

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"
  config.vm.provision :shell, :inline => "apt-get update --fix-missing"
  # Upgrade Chef automatically
  config.vm.provision :shell, :inline => "gem install --no-ri --no-rdoc puppet -v 3.3.2"

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  $puppet_command = "echo sudo puppet apply --modulepath /vagrant/modules /vagrant/manifests/default.pp -v > /vagrant/script.sh"
  config.vm.provision :shell, :inline => $puppet_command
  config.vm.provision :shell, :inline => "chmod u+x /vagrant/script.sh", :privileged => true
    
  #config.vm.provision :puppet do |puppet|
  #  puppet.module_path = "modules"
  #  puppet.manifests_path = "manifests"
  #  puppet.manifest_file = "default.pp"
  #  puppet.options = "--verbose"
  #  puppet.facter = {
  #    "fqdn" => "localhost"
  #  }
    #puppet.hiera_config_path = "hiera"
  #end
end

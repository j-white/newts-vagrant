# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # Newts
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 8081, host: 8081

  # Cassandra
  config.vm.network :forwarded_port, guest: 9042, host: 19042

  config.vm.provider :virtualbox do |vb|
     vb.name = "newts"

     vb.customize ["modifyvm", :id, "--memory", "4096"]
     vb.customize ["modifyvm", :id, "--ioapic", "on"]
     vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.manifest_file  = "site.pp"
     puppet.module_path = "modules"
     puppet.facter = {
         "vagrant" => "1"
     }
     puppet.options = ["--templatedir","/vagrant/templates"]
  end

end

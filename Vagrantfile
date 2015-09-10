# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # Newts - Graphite Lister
  config.vm.network :forwarded_port, guest: 2003, host: 2003
  # Newts - UI + ReST API
  config.vm.network :forwarded_port, guest: 8080, host: 18080
  # Newts - Dropwizard Admin/Operation Menu
  config.vm.network :forwarded_port, guest: 8081, host: 18081

  # Cassandra - CQL Native Transport
  config.vm.network :forwarded_port, guest: 9042, host: 9042
  # Cassandra - Thrift
  config.vm.network :forwarded_port, guest: 9160, host: 9160
  # Cassandra - JMX
  config.vm.network :forwarded_port, guest: 7199, host: 7199

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
         "vagrant" => "1",
         # The name of the branch or tag to build
         "newts_git_branch" => "master",
     }
     puppet.options = ["--templatedir","/vagrant/templates"]
  end

end

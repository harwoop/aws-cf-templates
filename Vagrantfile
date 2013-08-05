# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
#    vb.auto_nat_dns_proxy = false
    vb.customize [
      "modifyvm", :id,
#      "--cpuexecutioncap", "50",
      "--memory", "1024",
      "--cpus", "2",
      "--natdnspassdomain1", "off",
      ]
  end

  config.vm.define :stingray do |stingray|
    stingray.vm.box = "centos-64-x64"
    stingray.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    stingray.vm.network :private_network, ip: "10.0.0.20"
    stingray.vm.network :private_network, ip: "10.0.1.2"
    stingray.vm.network :forwarded_port, guest: 9090, host: 9090 # admin web interface
    stingray.vm.hostname = "stingray"
    stingray.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", "2048" ]
    end
    stingray.vm.provision :puppet,
      :options => ["--verbose", "--summarize"],
      :facter => { 
        "fqdn"   => "stingray",
      } do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file = "stingray.pp"
    end
    stingray.vm.provision :puppet,
      :facter => { 
        "fqdn"   => "stingray",
      } do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file = "stingray.pp"
    end
  end

  config.vm.define :webnode_01 do |webnode_01|
    webnode_01.vm.box = "centos-64-x64"
    webnode_01.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    webnode_01.vm.network :private_network, ip: "10.0.0.21"
    webnode_01.vm.hostname = "webnode-01"
    webnode_01.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", "512" ]
    end
    webnode_01.vm.provision :puppet,
      :facter => { 
        "fqdn" => "webnode-01",
      } do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file = "webnode.pp"
    end
  end

  config.vm.define :webnode_02 do |webnode_02|
    webnode_02.vm.box = "centos-64-x64"
    webnode_02.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    webnode_02.vm.network :private_network, ip: "10.0.0.22"
    webnode_02.vm.hostname = "webnode-02"
    webnode_02.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", "512" ]
    end
    webnode_02.vm.provision :puppet,
      :facter => { 
        "fqdn" => "webnode-02",
      } do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file = "webnode.pp"
    end
  end
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Shared folder
  config.vm.synced_folder "", "/vagrant", disabled: true
  config.vm.synced_folder "workspace/puppet/", "/puppet"

# All vm-wide puppet
  config.vm.provision :puppet do |puppet|
    puppet.module_path = "workspace/puppet"
    puppet.manifests_path = "Vagrant/puppet/manifests"
  end

#  config.vm.define "puppetmaster", do |puppetmaster|
#    puppetmaster.vm.box = "puppet-Centos6.4"
#    puppetmaster.vm.provision :puppet do |puppet|
#      puppet.manifest_file  = "puppetmaster.pp"
#      puppet.manifests_path = "Vagrant/puppet/manifests"
#    end
#  end

  config.vm.define "centos", primary: true do |centos|
    centos.vm.box = "terc-Centos6.5"
    centos.vm.provision :puppet do |puppet|
      puppet.manifest_file  = "centos.pp"
      puppet.manifests_path = "Vagrant/puppet/manifests"
    end
  end

  config.vm.define "fedora" do |fedora|
    fedora.vm.box = "terc-Fedora18"
    fedora.vm.provision :puppet do |puppet|
      puppet.manifests_path = "Vagrant/puppet/manifests"
      puppet.manifest_file  = "fedora.pp"
    end
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "puppet-Ubuntu12.04"
    ubuntu.vm.provision :puppet do |puppet|
      puppet.manifests_path = "Vagrant/puppet/manifests"
      puppet.manifest_file  = "ubuntu.pp"
    end
  end
end
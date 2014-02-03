require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  # Install Puppet & support
  install_package host, 'git'
  install_package host, 'rubygems'

  # host-specific repositories
  repos = {
    'centos-64-x64' => [
        [
          'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm' ,
          nil
        ],
        [
          'http://passenger.stealthymonkeys.com/rhel/6/passenger-release.noarch.rpm',
          'http://passenger.stealthymonkeys.com/RPM-GPG-KEY-stealthymonkeys.asc'
        ]
      ]
  }

  host_repos = repos[host.to_s] || []
  host_repos.each do |repo_url,gpg_key|
    puts "configuring #{host}-specific repo #{repo_url.inspect}"
    unless gpg_key.nil?
      shell("rpm --import #{gpg_key}")
    end
    shell("rpm -Uvh #{repo_url}")
  end

  pkgs = {
    'centos-64-x64' => %w(ruby-devel augeas-devel) ,
    'ubuntu-server-12042-x64' => %w(pkg-config libaugeas-dev)
  }
  
  host_pkgs = pkgs[host.to_s] || []
  host_pkgs.each do |pkg|
    puts "installing #{host}-specific package #{pkg}"
    install_package host, pkg
  end

  puts "installing puppet"
  on host, 'gem install puppet --no-ri --no-rdoc'
#  on host, 'gem install librarian-puppet-maestrodev --no-ri --no-rdoc'
  on host, 'gem install librarian-puppet --no-ri --no-rdoc'
  on host, 'gem install ruby-shadow --no-ri --no-rdoc'
  on host, 'gem install ruby-augeas --no-ri --no-rdoc'

  puts "creating module directory"
  on host, "mkdir -p #{host['distmoduledir']}"
end

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      puts 'installing this puppet module'
      puppet_module_install(:source => proj_root, :module_name => 'csrterc')
      puts 'installing modules dependencies via librarian-puppet'
      shell("cd #{host['distmoduledir']}/csrterc && librarian-puppet install --path=#{host['distmoduledir']}")
    end
  end
end

def default_manifest
  <<-EOS
    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
    File { owner => 0, group => 0, mode => 0644 }
  EOS
end

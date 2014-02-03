/*
stage { 'baseline':
  before => Stage['main'],
}

# container class implementation
class csrterc::baseline(
    $upgrade_upon_boot=false,
  ) {
  class { 'csrterc::baseline::users':, stage => 'baseline' }
  -> class { 'csrterc::baseline::update_repo':, stage => 'baseline' }
  -> class { 'csrterc::baseline::upgrade_repo':, stage => 'baseline' }
  -> class { 'csrterc::baseline::packages':, stage => 'baseline' }
  -> class { 'csrterc::baseline::helpers':, stage => 'baseline' }
}
*/
class csrterc::baseline(
    $upgrade_upon_boot=false,
  ) {
  class { 'csrterc::baseline::users': }
  -> class { 'csrterc::baseline::update_repo': }
  -> class { 'csrterc::baseline::upgrade_repo': }
  -> class { 'csrterc::baseline::packages': }
  -> class { 'csrterc::baseline::helpers': }
}

# ensure that the puppet user is present
class csrterc::baseline::users {
  group { 'puppet':
    ensure => 'present',
  }
}

# brings the system up-to-date after importing it with Vagrant
# runs after each boot (/tmp/ files are flused)
class csrterc::baseline::update_repo {
  case $::osfamily {
    'ubuntu', 'debian': {
      exec{'apt-get -y update && touch /tmp/apt-get-updated':
        unless => 'test -e /tmp/apt-get-updated'
      }
    }
    default: {
      # fail('have not implemented baseline::update_repo for non-debian OSs')
    }
  }
}

# brings the system up-to-date after importing it with Vagrant
# runs after each boot (/tmp/ files are flused)
class csrterc::baseline::upgrade_repo {
  if $baseline::upgrade_upon_boot == true {
    case $::osfamily {
      'ubuntu', 'debian': {
        exec{'apt-get -y upgrade && touch /tmp/apt-get-upgraded':
          unless => 'test -e /tmp/apt-get-upgraded'
        }
      }
      default: {
        # fail('have not implemented baseline::update_repo for non-debian OSs')
      }
    }
  }
}

# ensure that the puppet-supporting packages are present
class csrterc::baseline::packages {
  case $::osfamily {
    'ubuntu', 'debian': {
      # augeas support for puppet
      package { 'pkg-config':
        ensure => 'present' ,
      }
      -> package { 'libaugeas-dev':
        ensure => 'present' ,
      }
      -> package { 'augeas-tools':
        ensure => 'present' ,
      }
      -> package { 'augeas-lenses':
        ensure => 'present' ,
      }
    }
    'redhat': {
      # augeas support for puppet
      package { 'ruby-devel':
        ensure => 'present' ,
      }
      -> package { 'augeas-devel':
        ensure => 'present' ,
      }
    }
    default: {
      # nothing else so far    
    }
  }
#!!! gem provider is failing - don't know why!
#  -> package { 'ruby-augeas':
#    ensure => 'present' ,
#    provider => 'gem' ,
#  }

#  case $::osfamily {
#    'ubuntu', 'debian': {
#!!! gem provider is failing - don't know why!
#      # puppet needs ruby-shadow to manipulate passwords on ubuntu
##      package { 'ruby-shadow':
##        ensure => 'present' ,
##        provider => 'gem' ,
##      }
#    }
#    default: {
#      # ...
#    }
#  }
}

class csrterc::baseline::helpers(
    $path              = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/ruby/bin/',
    $puppet_bin_dir    = 'ruby',
    $puppet_config_dir = '/vagrant/puppet',
  ) {

  file{'/usr/local/bin/runpuppet':
    content => template('csrterc/baseline/run_puppet.sh.erb'),
    mode    => '0755' ,
    require => Class['csrterc::baseline::packages'],
  }

  file{'/usr/local/bin/runlibrarian':
    content => template('csrterc/baseline/run_puppet_librarian.sh.erb'),
    mode    => '0755' ,
    require => Class['csrterc::baseline::packages'],
  }
}

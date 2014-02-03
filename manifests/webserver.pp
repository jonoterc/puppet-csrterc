class csrterc::webserver { }

class csrterc::webserver::apache (
    $enable_default_mods = false ,
    $enable_rewrite      = true ,
    $enable_proxying     = true ,
    $listen_ports        = ['80'] , #['80', '8080', '3000'] ,
  ) {

  class { "::apache":
      default_mods   => $enable_default_mods ,
      package_ensure => 'present' ,
      default_vhost  => false ,
    }

  class { "::apache::dev": }

  if $enable_rewrite == true {
    ::apache::mod { "rewrite": }
  }

  if $enable_proxying == true {
    ::apache::mod { "proxy": }
    ::apache::mod { "proxy_html": }
    ::apache::mod { "proxy_http": }
  }

  ::apache::listen { $listen_ports: }
}

class csrterc::webserver::apache::passenger (
		$passenger_version ,
		$ruby_version ,
	) {
  
  class {
    'rvm::passenger::apache':
    version => $passenger_version ,
    ruby_version => $ruby_version ,
    require => [
    	Rvm_System_ruby[$ruby_version]
    ]
  }
}

define csrterc::webserver::apache::vhost(
    $site_path ,
    $site_name       = $name ,
    $site_domain     = undef ,
    $site_group_name = $name ,
    $site_owner_name = $name ,
    $site_root       = $site_path ,
    $site_mode       = 'development' ,
    $host_ip_address = undef ,
    $site_port       = undef ,
  ) {

	if $site_name {
		$use_site_domain = $site_domain 
	} else {
		case $site_mode {
			'development': {
				$use_site_domain = "${site_name}.dev"
			}
			'test': {
				$use_site_domain = "${site_name}.test"
			}
			'webdev': {
				$use_site_domain = "${site_name}.webdev"
			}
			'webtest': {
				$use_site_domain = "${site_name}.webtest"
			}
			default: { # same as production
			  fail('non-dev, non-test virtual hosts must specify a domain with the $site_name parameter.')
			}
		}
	}

  if $host_ip_address {
    $use_host_ip_address = $host_ip_address
  } else {
    case $site_mode {
      'development', 'test', 'webdev', 'webtest': {
        $use_host_ip_address = '127.0.0.1'
      }
      default: {
			  fail('non-dev, non-test virtual hosts must specify an IP address with $host_ip_address.')
      }
    }
  }

  if $site_port {
    $use_site_port = $site_port
  } else {
    case $site_mode {
      'development', 'test', 'webdev', 'webtest': {
        $use_site_port = '80'
      }
      default: {
			  fail('non-dev, non-test virtual hosts must specify a port with $site_port.')
      }
    }
  }

  host { "${use_site_domain}":
    ip => $use_host_ip_address ,
  }
  -> apache::vhost { $use_site_domain:
    ensure => "present" ,
    port           => $site_port ,
    docroot_group    => $site_group_name ,
    docroot_owner    => $site_owner_name ,
    docroot        => $site_root , # ??? this directory will be auto-generated ???
    custom_fragment => "PassengerRuby  ${ruby_path}\nRailsEnv  ${site_mode}" ,
  }

}

define csrterc::webserver::passenger::vhost(
    $site_path ,
    $ruby_path ,
    $site_name       = $name ,
    $site_domain     = undef ,
    $ruby_alias      = $name ,
    $gemset_name     = $name ,
    $site_group_name = $name ,
    $site_owner_name = $name ,
    $site_root       = $site_path ,
    $site_mode       = 'development' ,
    $host_ip_address = undef ,
    $site_port       = undef ,
  ) {

  # set ruby for the project directory
  # using .ruby-version instead of .rvmrc to bypass auto-prompting
  file { "${site_name} .ruby-version":
    ensure => "file" ,
    path => "${site_path}/.ruby-version" ,
    owner => $site_owner_name ,
    group => $site_group_name ,
    mode => 0664 ,
    content => "${ruby_alias}" # using the alias instead of the expanded name seems to work OK
  }
  -> file { "${site_name} .ruby-gemset":
    ensure => "file" ,
    path => "${site_path}/.ruby-gemset" ,
    owner => $site_owner_name ,
    group => $site_group_name ,
    mode => 0664 ,
    content => "${gemset_name}"
  }
  
  csrterc::webserver::apache::vhost(
    $site_path ,
    $site_name ,
    $site_domain ,
    $site_group_name ,
    $site_owner_name ,
    $site_root ,
    $site_mode ,
    $host_ip_address ,
    $site_port
  )

}

define csrterc::webserver::afp_share (
    $share_path = $name ,
    $user_name ,
    $share_label = undef
	) {
	
	if $share_label {
	  $use_share_label = $share_label
	} else {
	  $use_share_label = "afp-${name}-site"
	}
	
	csrterc::afp::share (
	  $use_share_label ,
	  $share_path ,
	  $user_name
	)
}

define csrterc::webserver::smb_share (
    $share_path = $name,
    $user_name ,
    $password ,
    $valid_users = undef ,
    $share_label = undef ,
	) {
	
	if $share_label {
	  $use_share_label = $share_label
	} else {
	  $use_share_label = "smb-${name}-site"
	}

	if $valid_users {
		$actual_valid_users = $valid_users
	} else {
		$actual_valid_users = $user_name
	}

	csrterc::smb::share (
	  $use_share_label ,
	  $share_path ,
	  $user_name ,
    $password ,
	  $actual_valid_users
	)

}

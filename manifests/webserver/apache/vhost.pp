define csrterc::webserver::apache::vhost(
    $site_path ,
    $site_name       = $title ,
    $site_domain     = undef ,
    $site_group_name = $title ,
    $site_owner_name = $title ,
    $site_root       = $site_path ,
    $site_mode       = 'development' ,
    $host_ip_address = undef ,
    $site_port       = undef ,
    $custom_fragment = undef ,
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

  host { $use_site_domain:
    ip => $use_host_ip_address ,
  }
  -> ::apache::vhost { $use_site_domain:
    ensure          => "present" ,
    port            => $use_site_port ,
    docroot_group   => $site_group_name ,
    docroot_owner   => $site_owner_name ,
    docroot         => $site_root ,
    custom_fragment => $custom_fragment ,
  }

}

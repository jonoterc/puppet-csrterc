define csrterc::webserver::apache::passenger::vhost(
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
    ensure  => "file" ,
    path    => "${site_path}/.ruby-version" ,
    owner   => $site_owner_name ,
    group   => $site_group_name ,
    mode    => 0664 ,
    content => "${ruby_alias}" # using the alias instead of the expanded name seems to work OK
  }
  -> file { "${site_name} .ruby-gemset":
    ensure  => "file" ,
    path    => "${site_path}/.ruby-gemset" ,
    owner   => $site_owner_name ,
    group   => $site_group_name ,
    mode    => 0664 ,
    content => "${gemset_name}"
  }
  
  csrterc::webserver::apache::vhost { $title:
    site_path       => $site_path ,
    site_name       => $site_name ,
    site_domain     => $site_domain ,
    site_group_name => $site_group_name ,
    site_owner_name => $site_owner_name ,
    site_root       => $site_root ,
    site_mode       => $site_mode ,
    host_ip_address => $host_ip_address ,
    site_port       => $site_port ,
    custom_fragment => "PassengerRuby  ${ruby_path}\nRailsEnv  ${site_mode}" ,
  }

}


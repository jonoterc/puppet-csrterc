class csrterc::webserver::apache (
    $enable_default_mods = false ,
    $enable_rewrite      = true ,
    $enable_proxying     = true ,
    $enable_sendfile     = true ,
    $listen_ports        = ['80'] , #['80', '8080', '3000'] ,
  ) {

  if $enable_sendfile == true {
    $sendfile_config = 'On'
  } else {
    $sendfile_config = 'Off'
  }

  class { '::apache':
      default_mods   => $enable_default_mods ,
      package_ensure => 'present' ,
      default_vhost  => false ,
      sendfile       => $sendfile_config ,
    }

  class { '::apache::dev': }

  if $enable_rewrite == true {
    ::apache::mod { 'rewrite': }
  }

  if $enable_proxying == true {
    ::apache::mod { 'proxy': }
    ::apache::mod { 'proxy_html': }
    ::apache::mod { 'proxy_http': }
  }

  ::apache::listen { $listen_ports: }
}


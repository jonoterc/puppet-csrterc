class csrterc::webapp::rvm_apache_passenger (
    $rvm_version ,
    $passenger_ruby ,
    $passenger_version ,
    $default_ruby               = undef ,
    $apache_enable_default_mods = undef ,
    $apache_enable_rewrite      = undef ,
    $apache_enable_proxying     = undef ,
    $apache_enable_sendfile     = undef ,
    $apache_listen_ports        = undef ,
  ) {

  if ! defined(Class['csrterc::rvm']) {
    class { 'csrterc::rvm':
      rvm_version  => $rvm_version ,
      default_ruby => $default_ruby ,
    }
  }

  if ! defined(Rvm_system_ruby[$passenger_ruby]) {
    rvm_system_ruby { $passenger_ruby:
      ensure      => 'present',
      default_use => false ,
      require     => Class['csrterc::rvm'] ,
    }
  }

  if ! defined(Class['csrterc::webserver::apache']) {
    class { 'csrterc::webserver::apache':
      enable_default_mods => $apache_enable_default_mods ,
      enable_rewrite      => $apache_enable_rewrite ,
      enable_proxying     => $apache_enable_proxying ,
      enable_sendfile     => $apache_enable_sendfile ,
      listen_ports        => $apache_listen_ports ,
      require             => Class['csrterc::rvm'] ,
    }
  }

  if ! defined(Class['csrterc::webserver::passenger']) {
    class { 'csrterc::webserver::apache::passenger':
      passenger_version => $passenger_version ,
      ruby_version      => $passenger_ruby ,
      require           => [
        Class['csrterc::webserver::apache'] ,
        Rvm_system_ruby[$passenger_ruby] ,
      ]
    }
  }

}

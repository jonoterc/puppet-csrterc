class csrterc::shortcut::rvm_apache_passenger (
    $rvm_version ,
    $passenger_ruby ,
    $passenger_version ,
    $default_ruby      = undef
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
      require => Class['csrterc::rvm'] ,
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

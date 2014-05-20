class csrterc::mysql (
    $root_password           = undef ,
    $remove_default_accounts = true ,
    $enable_java_bindings    = false ,
    $enable_python_bindings  = false ,
    $enable_perl_bindings    = false ,
    $enable_php_bindings     = false ,
    $enable_ruby_bindings    = false ,
  ) {

  class { '::mysql::server':
    root_password    => $root_password ,
    override_options => {
      restart                 => true ,
      remove_default_accounts => $remove_default_accounts ,
    } ,
  }

  if $enable_java_bindings == true or
      $enable_python_bindings == true or
      $enable_perl_bindings == true or
      $enable_php_bindings == true or
      $enable_ruby_bindings == true {

    class { '::mysql::bindings':
      require => Class['::mysql::server']
    }

    if $enable_java_bindings == true {
      class { '::mysql::bindings::java':
        require => Class['::mysql::bindings'] ,
      }
    }
    if $enable_python_bindings == true {
      class { '::mysql::bindings::python':
        require => Class['::mysql::bindings'] ,
      }
    }
    if $enable_perl_bindings == true {
      class { '::mysql::bindings::perl':
        require => Class['::mysql::bindings'] ,
      }
    }
    if $enable_php_bindings == true {
      class { '::mysql::bindings::php':
        require => Class['::mysql::bindings'] ,
      }
    }
    if $enable_ruby_bindings == true {
      class { '::mysql::bindings::ruby':
        require => Class['::mysql::bindings'] ,
      }
    }
  }
}

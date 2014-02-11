class csrterc::postgresql(
    $version = '9.3' ,
    $postgres_password = undef ,
    $encoding = 'UTF8' ,
    $locale = 'en_NG' ,
    $enable_plperl = false ,
    $enable_python_bindings = false ,
    $enable_java_bindings = false ,
  ) {

  $postgres_manage_repo = versioncmp($version, '9.1') > 0

  class { '::postgresql::globals':
    version => $version ,
    manage_package_repo  => $postgres_manage_repo,
    encoding => $encoding ,
    locale  => $locale ,
  }
  -> class { '::postgresql::server':
    postgres_password => $postgres_password ,
  }
  
  if $enable_plperl == true {
    class { '::postgresql::server::plperl': }
  }

  if $enable_python_bindings == true {
    class { '::postgresql::lib::python': }
  }

  if $enable_java_bindings == true {
    class { '::postgresql::lib::java': }
  }
}

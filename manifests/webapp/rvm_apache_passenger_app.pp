define csrterc::webapp::rvm_apache_passenger_app (
    $app_ruby ,
    $app_domain ,
    $app_user_password        = undef ,
    $app_user_hashed_password = undef ,
    $app_name                 = $title ,
    $app_user                 = $title ,
    $app_user_home            = undef ,
    $app_directory            = $title ,
    $app_ruby_alias           = $title ,
    $app_rubygems             = undef ,
    $app_gemset               = $title ,
    $app_group                = $user ,

    $apps_path                = '/var/apps',
    $app_bundle_install       = false ,
    $app_mode                 = 'development' ,
    $app_mode_passenger_var   = undef ,
    $passenger_custom_config  = undef ,

    $mysql_enabled            = false ,
    $mysql_app_db             = undef ,
    $mysql_test_db            = undef ,

    $postgresql_enabled       = false ,
    $postgresql_app_db        = undef ,
    $postgresql_test_db       = undef ,

    $vcs_provider             = undef ,
    $vcs_repo_url             = undef ,
    $vcs_auth_username        = undef ,
    $vcs_auth_password        = undef ,

    $afp_enabled              = false ,
    $smb_enabled              = false ,
  ) {

  if $app_user_home != undef {
    $app_user_home_path = $app_user_home
  } else {
    $app_user_home_path = "/home/${app_user}"
  }

  #####
  # app-specific user account with login and rvm
  #####

  if ! defined(Csrterc::User[$app_user]) {

    if $app_user_password == undef or $app_user_hashed_password == undef {
      fail("csrterc::webapp::rvm_apache_passenger requires both app_user_password and app_user_hashed_password variables, as app_user:'${app_user}' does not already exist and must be created")
    }

    csrterc::user { $app_user:
      plaintext_password => $app_user_password ,
      hashed_password    => $app_user_hashed_password ,
      home_path          => $app_user_home_path ,
      rvm_user           => true ,
    }
  }

  #####
  # general and app-specific directories
  #####

  if ! defined(File[$apps_path]) {
    file { $apps_path:
      ensure => 'directory' ,
      mode   => '0644' ,
    }
  }

  $app_path = "${apps_path}/${app_directory}"

  file { $app_path:
    ensure  => 'directory' ,
    owner   => $app_user ,
    group   => $app_group ,
    mode    => '0644' ,
    require => [
      File[$apps_path] ,
    ] ,
  }

  #####
  # cross-link app-specific directory from app-specific user account home
  #####

  if ($app_user_home != false) {

    $app_user_home_apps_path = "${app_user_home_path}/apps"

    file { $app_user_home_apps_path:
      ensure  => 'directory' ,
      owner   => $app_user ,
      group   => $app_group ,
      mode    => '0644' ,
      require => [
        Csrterc::User[$app_user] ,
      ] ,
    }

    file { "${app_user_home_apps_path}/${app_name}":
      ensure  => 'link' ,
      target  => $app_path ,
      require => [
        File[$app_user_home_apps_path] ,
        File[$app_path] ,
      ] ,
    }

  }

  #####
  # app-specific ruby, rubygems, gemset
  #####

  if ! defined(Rvm_system_ruby[$app_ruby]) {
    rvm_system_ruby { $app_ruby:
      ensure  => 'present',
      require => Class['csrterc::rvm'] ,
    }
  }

  if $app_rubygems != undef {
    # rvm rubygems latest-1.8
    $app_rubygems_regex = regsubst($app_rubygems,'\D*(\d+\.\d+\.?).*','\1')

    exec { "revert ${app_ruby} rubygems":
      command  => "sudo /bin/bash --login -c 'source /usr/local/rvm/scripts/rvm && rvm use '${app_ruby}' && rvm rubygems ${app_rubygems} --force'" ,
      unless   => "/bin/bash --login -c '(source /usr/local/rvm/scripts/rvm && rvm use '${app_ruby}' && gem -v) | grep ''^${app_rubygems_regex}'' '" ,
      provider => 'shell' ,
      require  => Rvm_system_ruby[$app_ruby] ,
    }
  }

  $app_ruby_gemset = "${app_ruby}@${app_gemset}"
  $app_ruby_alias_gemset = "${app_ruby_alias}@${app_gemset}"

  rvm_alias { $app_ruby_alias:
    ensure      => present ,
    target_ruby => $app_ruby ,
    require     => Rvm_system_ruby[$app_ruby] ,
  }
  -> rvm_gemset { $app_ruby_alias_gemset:
    ensure  => present ,
    require => Rvm_alias[$app_ruby_alias] ,
  }

  #####
  # optional installation of app from vcs, with optional bundler install
  #####

  $use_vcs = ( $vcs_provider != undef and $vcs_repo_url != undef )

  $app_log_path = "${app_path}/log"
  $app_public_path = "${app_path}/public"
  $app_public_system_path = "${app_public_path}/system"

  if ($use_vcs) {

    vcsrepo { $app_path:
      ensure              => 'present' ,
      provider            => $vcs_provider ,
      source              => $vcs_repo_url ,
      basic_auth_username => $vcs_auth_username ,
      basic_auth_password => $vcs_auth_password ,
      owner               => $app_user ,
      group               => $app_group ,

      require             => File[$app_path] ,
    }

    if $app_bundle_install == true {
      if ! defined(File[$app_log_path]) {
        file { $app_log_path:
          ensure  => 'directory' ,
          owner   => $app_user ,
          group   => $app_group ,
          mode    => '0644' ,
          require => [
            Csrterc::User[$app_user] ,
            Vcsrepo[$app_path] ,
          ] ,
        }
      }

      $app_bundle_install_log_path = "/home/${app_user}/bundle_install_${app_name}_${app_ruby}.log"

      exec { "bundle install ${app_path}":
        command  => "/bin/su --login --shell /bin/bash -c 'source /usr/local/rvm/scripts/rvm && rvm use ${app_ruby_gemset} && cd \"${app_path}\" && mkdir -p log && bundle install > \"${app_bundle_install_log_path}\"' ${app_user}" ,
        unless   => "ls -al \"${app_bundle_install_log_path}\"" ,
        provider => 'shell' ,
        require  => [
          Csrterc::User[$app_user] ,
          Rvm_system_ruby[$app_ruby] ,
          Vcsrepo[$app_path] ,
          File[$app_log_path] ,
        ]
      }
    }

    $app_public_path_requirements = [ Vcsrepo[$app_path] ]

    $vhost_requirements = [ Csrterc::User[$app_user], File[$app_public_system_path], Vcsrepo[$app_path] ]

  } else {

    $app_public_path_requirements = [ File[$app_path] ]

    $vhost_requirements = [ Csrterc::User[$app_user], File[$app_public_system_path] ]
  }

  if ! defined(File[$app_public_path]) {
    file { $app_public_path:
      ensure  => 'directory' ,
      owner   => $app_user ,
      group   => $app_group ,
      mode    => '0644' ,
      require => $app_public_path_requirements ,
    }
  }

  file { $app_public_system_path:
    ensure  => 'directory' ,
    owner   => $app_user ,
    group   => $app_group ,
    mode    => '0644' ,
    require => [
      File[$app_public_path]
    ] ,
  }

  csrterc::webserver::apache::passenger::vhost { $app_name:
    site_path       => $app_path ,
    ruby_path       => "/usr/local/rvm/wrappers/${app_ruby_gemset}/ruby" ,
    site_domain     => $app_domain ,
    site_root       => $app_public_path ,
    site_owner_name => $app_user ,
    site_group_name => $app_group ,
    site_mode       => $app_mode ,
    site_mode_var   => $app_mode_passenger_var ,
    custom_config   => $passenger_custom_config ,
    require         => $vhost_requirements ,
  }

  #####
  # mysql database support
  #####
  if $mysql_app_db != undef and $mysql_app_db != false {

    if ! defined(Class['csrterc::mysql']) {
      fail('csrterc::webapp:rvm_apache_passenger_app failure; csrterc::mysql support must be provided when $mysql_enabled is true')
    }

    if $mysql_app_db == true {
      csrterc::user::mysql_db { "${app_name}_${app_mode}": }
    } else {
      csrterc::user::mysql_db { $mysql_app_db: }
    }

    if ( $mysql_test_db != undef and $mysql_test_db != false ) {
      if $mysql_test_db == true {
        csrterc::user::mysql_db { "${app_name}_test": }
      } else {
        csrterc::user::mysql_db { $mysql_test_db: }
      }
    }

  }

  #####
  # postgresql database support
  #####
  if $postgresql_app_db != undef and $postgresql_app_db != false {

    if ! defined(Class['csrterc::postgresql']) {
      fail('csrterc::webapp:rvm_apache_passenger_app failure; csrterc::postgresql support must be provided when $postgresql_enabled is true')
    }

    if $postgresql_app_db == true {
      csrterc::user::postgresql_db { "${app_name}_${app_mode}": }
    } else {
      csrterc::user::postgresql_db { $postgresql_app_db: }
    }

    if ( $postgresql_test_db != undef and $postgresql_test_db != false ) {
      if $postgresql_test_db == true {
        csrterc::user::postgresql_db { "${app_name}_test": }
      } else {
        csrterc::user::postgresql_db { $postgresql_test_db: }
      }
    }

  }

  #####
  # afp networking shares support
  #####

  if ($afp_enabled) {
    if ! defined(Class['csrterc::afp']) {
      class { 'csrterc::afp':
        server_name => "posterhall ${app_mode} AFP" ,
      }
    }

    if ($app_user_home != false) {
      csrterc::user::afp_share { $app_user:
        require => [
          Class['csrterc::afp'] ,
          Csrterc::User[$app_user] ,
        ] ,
      }
    }

    csrterc::webserver::afp_share { $app_user:
      user_name  => $app_user ,
      share_path => $app_path ,
      require    => [
        Class['csrterc::afp'] ,
        File[$app_path] ,
      ] ,
    }
  }

  #####
  # smb networking shares support
  #####

  if ($smb_enabled == true) {
    if ! defined(Class['csrterc::smb']) {
      class { 'csrterc::smb':
        server_name   => 'development' ,
        server_string => "posterhall ${app_mode} SMB" ,
      }
    }

    if ($app_user_home != false) {
      csrterc::user::smb_share { $app_user:
        password => $app_user_password ,
        require  => [
          Class['csrterc::smb'] ,
          Csrterc::User[$app_user] ,
        ] ,
      }
    }

    csrterc::webserver::smb_share { $app_user:
      user_name  => $app_user ,
      password   => $app_user_password ,
      share_path => $app_path ,
      require    => [
        Class['csrterc::smb'] ,
        File[$app_path] ,
      ] ,
    }
  }

}

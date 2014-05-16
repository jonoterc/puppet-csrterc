define csrterc::rvm::system_user (
    $system_path ,
    $user  => $name ,
    $group => undef ,
  ) {

  if ( $group != undef ) {
    $use_group = $group
  } else {
    $use_group = $user
  }

  file { "${system_path}.ruby-version":
    content => 'system' ,
    mode    => '0644' ,
    owner   => "${user}" ,
    group   => "${use_group}" ,
    require => [
      Class['csrterc::rvm'] ,
    ] ,
  }

}

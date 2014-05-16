define csrterc::rvm::opt_out_user (
    $home_path => undef ,
    $user      => $title ,
    $group     => undef ,
  ) {

  if $home_path {
    $opt_out_path = $home_path
  } else {
    $opt_out_path = "/home/${user}"
  }

  if ( $group != undef ) {
    $use_group = $group
  } else {
    $use_group = $user
  }

  file { "${opt_out_path}.ruby-version":
    content => 'system' ,
    mode    => '0644' ,
    owner   => $user ,
    group   => $use_group ,
    require => [
      Class['csrterc::rvm'] ,
    ] ,
  }

}

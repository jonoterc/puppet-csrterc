class csrterc::afp (
    $server_name = '-' ,
    $server_options = undef ,
  ) {
  netatalk::server { $server_name:
    options => $server_options
  }
}

define csrterc::afp::share (
  $share_label = $name ,
  $share_path ,
  $share_user ,
) {
  netatalk::volume { $share_label:
    name => $share_label ,
    path => $share_path ,
    options => "allow:${share_user} options:usedots,upriv,invisibledots,noadouble" ,
    require => [
        User[$share_user] ,
      ] ,
  }
}

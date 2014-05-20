class csrterc::afp (
    $server_name    = '-' ,
    $server_options = undef ,
  ) {
  netatalk::server { $server_name:
    options => $server_options
  }
}


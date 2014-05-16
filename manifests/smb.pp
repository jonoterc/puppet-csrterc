class csrterc::smb (
    $server_name = '-' ,
    $server_string = 'SMB Server' ,
    $interfaces = 'eth0 lo' ,
    $security = 'user' ,
  ) {

  class {'samba::server':
    workgroup => $server_name ,
    server_string => $server_string ,
    interfaces => $interfaces ,
    security => $security ,
    unix_password_sync => false ,
  }
}


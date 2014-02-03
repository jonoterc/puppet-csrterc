class csrterc::smb (
    $server_name = '-' ,
    $server_string = 'SMB Server' ,
    $interfaces = undef, #= 'eth0 lo' ,
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

define csrterc::smb::share (
    $share_path ,
    $share_label = $name ,
    $user_name ,
    $password ,
    $valid_users = undef ,
  ) {

	$share_label = "smb-${name}-site" 

	samba::server::share { $share_label:
		comment => "smb volume for ${share_path}" ,
		path           => $share_path ,
		guest_only     => false ,
		guest_ok       => false ,
		browsable      => true ,
		writable       => true ,
		create_mask    => 0777 ,
		directory_mask => 0777 ,
		valid_users    => $actual_valid_users ,
	}
	
	if ! defined(Samba::Server::User[$user_name]) {
		samba::server::user { $user_name:
			password => $password ,
			require => Samba::Server::Share[$share_label]
		}
	}

}

define csrterc::smb::share (
    $share_label = $name ,
    $share_path ,
    $share_user ,
    $password ,
    $valid_users = undef ,
  ) {

	# $share_label = "smb-${name}-site" 

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
	
	if ! defined(Samba::Server::User[$share_user]) {
		samba::server::user { $share_user:
			password => $password ,
			require => Samba::Server::Share[$share_label]
		}
	}

}

define csrterc::developer::smb_share (
    $user_name  = $title ,
    $password ,
    $share_path = undef
	) {
	
	if $share_path {
		$smb_share_path = $share_path
	} else {
		$smb_share_path = "/home/${user_name}/"
	}
	
	$share_name = "smb-${user_name}-home"
	
	samba::server::share { $share_name:
		comment        => "smb volume for ${user_name}" ,
		path           => $smb_share_path ,
		guest_only     => false ,
		guest_ok       => false ,
		browsable      => true ,
		writable       => true ,
		create_mask    => 0777 ,
		directory_mask => 0777 ,
		valid_users    => "${user_name}" ,
	}

	if ! defined(Samba::Server::User[$user_name]) {
		samba::server::user { $user_name:
			password => $password ,
			require  => Samba::Server::Share[$share_name] ,
		}
	}

}


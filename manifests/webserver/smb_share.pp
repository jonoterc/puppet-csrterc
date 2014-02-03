define csrterc::webserver::smb_share (
    $share_path = $name,
    $user_name ,
    $password ,
    $valid_users = undef ,
    $share_label = undef ,
	) {
	
	if $share_label {
	  $use_share_label = $share_label
	} else {
	  $use_share_label = "smb-${name}-site"
	}

	if $valid_users {
		$actual_valid_users = $valid_users
	} else {
		$actual_valid_users = $user_name
	}

	csrterc::smb::share (
	  $use_share_label ,
	  $share_path ,
	  $user_name ,
    $password ,
	  $actual_valid_users
	)

}

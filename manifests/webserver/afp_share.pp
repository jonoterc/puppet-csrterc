define csrterc::webserver::afp_share (
    $share_path = $name ,
    $user_name ,
    $share_label = undef
	) {
	
	if $share_label {
	  $use_share_label = $share_label
	} else {
	  $use_share_label = "afp-${name}-site"
	}
	
	csrterc::afp::share (
	  $use_share_label ,
	  $share_path ,
	  $user_name
	)
}


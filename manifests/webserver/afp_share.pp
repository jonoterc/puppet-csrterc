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
	
	csrterc::afp::share { $title:
	  share_label => $use_share_label ,
	  share_path  => $share_path ,
	  share_user  => $user_name
	}
}


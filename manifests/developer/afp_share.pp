define csrterc::developer::afp_share (
    $user_name  = $title ,
    $share_path = undef
	) {
	
	if $share_path {
		$afp_share_path = $share_path
	} else {
		$afp_share_path = "/home/${user_name}/"
	}
	
	netatalk::volume { "afp volume for ${user_name}":
		name    => "afp-${user_name}-home",
		path    => $afp_share_path ,
		options => "allow:${user_name} options:usedots,upriv,invisibledots,noadouble" ,
		require => [
				User[$user_name] ,
			] ,
	}
}


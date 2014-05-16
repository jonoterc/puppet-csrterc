define csrterc::user (
    $plaintext_password ,
    $hashed_password ,
    $user_name              = $title ,
    $group_name             = $title ,
    $home_path              = undef ,
    $user_shell             = '/bin/bash' ,
    $additional_user_groups = ["sudo"] ,
    $rvm_user               = false ,
  ) {

  if $group_name != undef {
    group { $group_name:
      ensure => "present"
    }
  }

  if $home_path == false {
    $user_home_path = undef
  } elsif defined($home_path) {
    $user_home_path = $home_path
  } else {
    $user_home_path = "/home/${user_name}/"
  }

  case $::osfamily {
    default: {
      if $group_name != undef {
        $user_requirements = [
          Group[$group_name] ,
        ]
      } else {
        $user_requirements = []
      }
    }
  }
  
  user { $user_name:
    ensure     => "present" ,
    managehome => true ,
    password   => $hashed_password ,
    home       => $user_home_path ,
    shell      => $user_shell ,
    gid        => $group_name ,
    groups     => $additional_user_groups ,
    require    => $user_requirements
  }

  # ensure password is set on the first pass,
  # which is not otherwise happening on ubuntu
  -> exec { "correct ${user_name} password":
    command => "usermod -p '${hashed_password}' ${user_name}" ,
    onlyif  => "egrep -q '^${user_name}:!:' /etc/shadow" ,
    require => [
        User[$user_name] ,
        Group[$group_name] ,
      ],
  }

	if $rvm_user == true {
  	::rvm::system_user { $user_name: }
	}

}


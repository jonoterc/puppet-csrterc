define csrterc::developer (
    $plaintext_password ,
    $hashed_password         = undef ,
    $user_name               = $title ,
    $group_name              = $title ,
    $has_home_path           = true ,
    $user_shell              = '/bin/bash' ,
    $additional_user_groups  = ["sudo"] ,
    $rvm_user                = false ,
    $password_hash_algorithm = undef ,
    $password_hash_salt      = undef ,
  ) {

  if $group_name != undef {
    group { $group_name:
      ensure => "present"
    }
  }

  if $has_home_path == true {
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
  
  if $hashed_password != undef {
    $use_hashed_password = hashed_password
  } else {
    if $password_hash_algorithm != undef {
      $use_password_hash_algorithm = $password_hash_algorithm
    } else {
      case $::osfamily {
        'ubuntu', 'debian': {
          $use_password_hash_algorithm = 'SHA512'
        }
        default: {
          $use_password_hash_algorithm = 'MD5'
        }
      }
    }
    
    case $use_password_hash_algorithm {
      'MD5': {
        if $password_hash_salt != undef {
          $use_hashed_password = unix_md5($plaintext_password, $password_hash_salt)
        } else {
          $use_hashed_password = unix_md5($plaintext_password)
        }
      }
      'SHA256': {
        if $password_hash_salt != undef {
          $use_hashed_password = unix_sha256($plaintext_password, $password_hash_salt)
        } else {
          $use_hashed_password = unix_sha256($plaintext_password)
        }
      }
      'SHA512': {
        if $password_hash_salt != undef {
          $use_hashed_password = unix_sha512($plaintext_password, $password_hash_salt)
        } else {
          $use_hashed_password = unix_sha512($plaintext_password)
        }
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
  case $::osfamily {
    'ubuntu': {
      exec { "correct ${user_name} password":
        command => "usermod -p '${hashed_password}' ${user_name}" ,
        onlyif  => "egrep -q '^${user_name}:!:' /etc/shadow" ,
        require => [
            User[$user_name] ,
            Group[$group_name] ,
          ],
      }
    }
  }

	if $rvm_user == true {
  	::rvm::system_user { $user_name: }
	}

}


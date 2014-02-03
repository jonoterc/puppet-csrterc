define csrterc::developer (
    $plaintext_password ,
    $crypted_password ,
    $user_name              = $title ,
    $group_name             = $title ,
    $has_home_path          = true ,
    $user_shell             = '/bin/bash' ,
    $additional_user_groups = ["sudo"] ,
    $rvm_user               = false ,
  ) {

  if $group_name != undef {
    group { "${group_name}":
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
          Group["${group_name}"] ,
        ]
      } else {
        $user_requirements = []
      }
    }
  }
  
  user { "${user_name}":
    ensure     => "present" ,
    managehome => true ,
    password   => "${crypted_password}" ,
    home       => "${user_home_path}" ,
    shell      => "${user_shell}" ,
    gid        => "${group_name}" ,
    groups     => $additional_user_groups ,
    require    => $user_requirements
  }

  # ensure password is set on the first pass,
  # which is not otherwise happening on ubuntu
  -> exec { "correct ${user_name} password":
    command => "usermod -p '${crypted_password}' ${user_name}" ,
    onlyif  => "egrep -q '^${user_name}:!:' /etc/shadow" ,
    require => [
        User["${user_name}"] ,
        Group["${group_name}"] ,
      ],
  }

	if $rvm_user == true {
  	::rvm::system_user { $user_name: }
	}

}

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

define csrterc::developer::sqlite_db (
    $user_name = $title ,
		$db_path   = undef ,
	) {

	if $db_path {
		$sqlite_db_path = "${db_path}/${user_name}.sqlite3"
	} else {
		$sqlite_db_path = "/home/${user_name}/${user_name}.sqlite3"
	}

	if $group_id {
		$sqlite_group_id = $group_id
	} else {
		$sqlite_group_id = 0
	}

	sqlite::db { $user_name:
		location   => $sqlite_db_path ,
		owner      => $user_name ,
		group      => $sqlite_group_id ,
		mode       => '755' ,
		ensure     => present ,
		sqlite_cmd => 'sqlite' ,
	}

}

define csrterc::developer::postgresql_db (
    $user_name = $title ,
    $password = '' ,
	) {

	postgresql::server::db { $user_name:
		user     => $user_name,
		password => $password,
	}

}

define csrterc::developer::mysql_user (
    $user_name = $title ,
    $password = '' ,
    $host = 'localhost' ,
	) {

	if !defined( Mysql_user["${user_name}@${host}"] ) {
		mysql_user { "${user_name}@${host}":
			ensure        => present ,
			password_hash => mysql_password($password) ,

			require => [
				User[$user_name] ,
			] ,
		}
	}
}


define csrterc::developer::mysql_db (
    $user_name = $title ,
	) {

  mysql_database { $user_name:
    ensure     => 'present' ,
    provider   => 'mysql',
    require    => [ Class['mysql::server'] ],
  }

}

define csrterc::developer::mysql_grant (
    $user_name     = $title ,
    $database_name = $title ,
    $table_name    = '*' ,
    $host_name     = 'localhost' ,
    # $password    = '' ,
	) {

	mysql_grant { "${user_name}@${host_name}/${database_name}.${table_name}":
		ensure     => 'present' ,
		options    => ['GRANT'] ,
		privileges => ['ALL'] ,
		table      => "${database_name}.${table_name}" ,
		user       => "${user_name}@${host_name}" ,
		
		require => [
			Mysql_database[$database_name] ,
			Mysql_user["${user_name}@${host_name}"] ,
		]
	}

}

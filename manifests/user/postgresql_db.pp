define csrterc::user::postgresql_db (
    $user_name = $title ,
    $password = '' ,
	) {

	postgresql::server::db { $user_name:
		user     => $user_name,
		password => $password,
	}

}


define csrterc::user::mysql_grant (
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

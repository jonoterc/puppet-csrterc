define csrterc::developer::mysql_db (
    $user_name = $title ,
	) {

  mysql_database { $user_name:
    ensure     => 'present' ,
    provider   => 'mysql',
    require    => [ Class['mysql::server'] ],
  }

}

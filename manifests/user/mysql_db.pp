define csrterc::user::mysql_db (
    $user_name = $title ,
    $charset     = 'utf8',
    $collate     = 'utf8_unicode_ci',
  ) {

  mysql_database { $user_name:
    ensure     => 'present',
    provider   => 'mysql',
    charset    => $charset,
    collate    => $collate,
    require    => [ Class['mysql::server'] ],
  }

}

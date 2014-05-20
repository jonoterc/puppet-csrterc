define csrterc::user::sqlite_db (
    $user_name = $title ,
    $db_path   = undef ,
    $group_id  = undef ,
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
    ensure     => present ,
    location   => $sqlite_db_path ,
    owner      => $user_name ,
    group      => $sqlite_group_id ,
    mode       => '755' ,
    sqlite_cmd => 'sqlite' ,
  }

}




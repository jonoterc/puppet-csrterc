define csrterc::user::mysql_user (
    $user_name = $title ,
    $password  = '' ,
    $host      = 'localhost' ,
  ) {

  if !defined( Mysql_user["${user_name}@${host}"] ) {
    mysql_user { "${user_name}@${host}":
      ensure        => present ,
      password_hash => mysql_password($password) ,
      require       => [
        User[$user_name] ,
      ] ,
    }
  }
}


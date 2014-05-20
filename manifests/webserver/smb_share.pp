define csrterc::webserver::smb_share (
    $user_name ,
    $password ,
    $valid_users = undef ,
    $share_label = undef ,
    $share_path  = $title ,
  ) {

  if $share_label {
    $use_share_label = $share_label
  } else {
    $use_share_label = "smb-${name}-site"
  }

  if $valid_users {
    $actual_valid_users = $valid_users
  } else {
    $actual_valid_users = $user_name
  }

  csrterc::smb::share { $title:
    share_label => $use_share_label ,
    share_path  => $share_path ,
    share_user  => $user_name ,
    password    => $password ,
    valid_users => $actual_valid_users
  }

}

class csrterc::shortcut::app_mode_default (
    $app_mode      = 'development' ,
    $app_mode_var  = 'RAILS_ENV' ,
    $app_mode_file = $app_mode_var ,
  ) {
  file { "/etc/profile.d/${app_mode_file}.sh":
    ensure  => 'file' ,
    content => "export ${app_mode_var}=${app_mode}" ,
    mode    => '0644'
  }
}
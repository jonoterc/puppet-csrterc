class csrterc::ssh {
  class { 'ssh::client': }
  -> class { 'ssh::server':
    password_authentication => 'yes' ,
    # pubkey_authentication => 'yes' ,
  }
}

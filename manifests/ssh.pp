class csrterc::ssh {
  class { 'ssh::client': }
  -> class { 'ssh::server': }
}

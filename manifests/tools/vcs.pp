class csrterc::tools::vcs (
    $enable_svn = true ,
    $enable_git = true ,
  ) {
  if $enable_svn == true {
    if ! defined(Package['subversion']) {
      package{ 'subversion':
        ensure => installed
      }
    }
  }
  if $enable_git == true {
    if ! defined(Package['git']) {
      package{ 'git':
        ensure => installed
      }
    }
  }
}


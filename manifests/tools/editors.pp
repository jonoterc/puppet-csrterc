class csrterc::tools::editors (
    $enable_emacs = true ,
    $enable_vim   = true ,
    $enable_nano  = true ,
  ) {
  if $enable_emacs == true {
    case $::osfamily {
      'ubuntu', 'debian': {
        package{ 'emacs23-nox':
          ensure => installed
        }
      }
      default: {
        package{ 'emacs-nox':
          ensure => installed
        }
      }
    }
  }
  if $enable_vim == true {
    if $::osfamily == 'redhat' {
      package{ 'vim-enhanced':
        ensure => installed
      }
    } else {
      package{ 'vim':
        ensure => installed
      }
    }
  }
  if $enable_nano == true {
    package{ 'nano':
      ensure => installed
    }
  }
}

class csrterc::tools {
  class { 'csrterc::tools::editors': }
  -> class { 'csrterc::tools::versioning': }
  -> class { 'csrterc::tools::miscellany': }
}

class csrterc::tools::editors (
    $enable_emacs = true ,
    $enable_vim = true ,
    $enable_nano = true ,
	) {
  if $enable_emacs == true {
    case $::osfamily {
      'ubuntu', 'debian': {
        package{ 'emacs23-nox':  ensure => installed }
      }
      default: {
        package{ 'emacs-nox':  ensure => installed }
      }
    }    
  }
  if $enable_vim == true {
    if $::osfamily == 'redhat' {
      package{ 'vim-enhanced':  ensure => installed }
    } else {
      package{ 'vim':  ensure => installed }
    }
  }
  if $enable_nano == true {
    package{ 'nano':  ensure => installed }
  }
}

class csrterc::tools::versioning (
    $enable_svn = true ,
    $enable_git = true ,
	) {
  if $enable_svn == true {
		if ! defined(Package['subversion']) { 
  	  package{ 'subversion':  ensure => installed }
  	}
  }
  if $enable_git == true {
		if ! defined(Package['git']) { 
	    package{ 'git':  ensure => installed }
	  }
  }
}

class csrterc::tools::miscellany {
	if ! defined(Package['curl']) { 
	  package{ 'curl':  ensure => installed }
	}
	if ! defined(Package['wget']) { 
	  package{ 'wget':  ensure => installed }
	}
}

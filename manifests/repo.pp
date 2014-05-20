class csrterc::repo {

  case $::osfamily {
    'ubuntu', 'debian': {
      class { '::apt': }
    }
    'redhat': {
      # ? class { 'yum': }
    }
    default : {
    }
  }

}


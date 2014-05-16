class csrterc::rvm (
    $rvm_version = undef ,
    $default_ruby = undef ,
  ) {

  class { '::rvm':
    version => $rvm_version ,
  }
  
  if $default_ruby {
  	rvm_system_ruby { $default_ruby :
    	ensure => 'present' ,
    	default_use => true ,
      require => [
      	Class['::rvm'] ,
      ] ,
	  }
  }
  
}

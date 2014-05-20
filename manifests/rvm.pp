class csrterc::rvm (
    $rvm_version = undef ,
    $default_ruby = undef ,
  ) {

  class { '::rvm':
    version => $rvm_version ,
  }
  
  class { '::rvm::rvmrc':
    max_time_flag => '20' ,
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

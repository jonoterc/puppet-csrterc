class csrterc::rvm (
    $rvm_version = undef ,
    $default_ruby = undef ,
    $system_ruby_path = undef ,
    $system_ruby_user = undef ,
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
  
  if $system_ruby_path {
    file { "${system_ruby_path}.ruby-version":
      content => 'system' ,
      mode    => '0644' ,
      owner   => "${system_ruby_user}" ,
      group   => "${system_ruby_user}" ,
      require => [
      	Class['::rvm'] ,
      ] ,
    }
  }
}

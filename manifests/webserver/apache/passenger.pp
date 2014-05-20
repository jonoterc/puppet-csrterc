class csrterc::webserver::apache::passenger (
    $passenger_version ,
    $ruby_version ,
  ) {

  class {
    'rvm::passenger::apache':
    version      => $passenger_version ,
    ruby_version => $ruby_version ,
    require      => [
      Rvm_System_ruby[$ruby_version]
    ]
  }
}


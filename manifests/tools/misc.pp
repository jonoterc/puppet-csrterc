class csrterc::tools::misc {
  if ! defined(Package['curl']) {
    package{ 'curl':
      ensure => installed
    }
  }
  if ! defined(Package['wget']) {
    package{ 'wget':
      ensure => installed
    }
  }
}

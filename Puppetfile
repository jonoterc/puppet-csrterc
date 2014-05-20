forge 'http://forge.puppetlabs.com'

## support modules
# force a more recent stdlib
mod 'puppetlabs/stdlib', '4.1.0'
# supports puppetlabs/postgresql on ubuntu
mod 'puppetlabs/apt', '1.4.0'

## networking
mod 'attachmentgenie/ssh', '1.2.1'
mod 'rcoleman/netatalk', '0.3.0'
mod 'ajjahn/samba', '0.2.0'

## monitoring
mod 'example42/monit', '2.0.13'

## databases
mod 'puppetlabs/sqlite', '0.0.1'
mod 'puppetlabs/mysql', '2.1.0'
mod 'puppetlabs/postgresql', '3.3.0'

## webserver
# restore this once the package_ensure bugfix has been released on puppetforge
# fork fix merged, waiting on official forge release
# mod 'puppetlabs/apache', '???'
mod 'puppetlabs/apache', # using full name to ensure this is recognized by dependent modules
  :git => "https://github.com/jonoterc/puppetlabs-apache.git",
  :ref => 'fix_passenger_redhat'

## rvm/ruby
# mod 'maestrodev/rvm', '1.2.0'
mod 'maestrodev/rvm',
  :git => "https://github.com/jonoterc/puppet-rvm.git",
  :ref => 'mod-passenger'

## version control
# fork fix merged, waiting on official forge release
# mod 'puppetlabs/vcsrepo', '???'
mod 'puppetlabs/vcsrepo',
  :git => "https://github.com/jonoterc/puppetlabs-vcsrepo.git" ,
  :ref => 'fix_svnlook'

forge 'http://forge.puppetlabs.com'

## support modules
# force a more recent stdlib
mod 'puppetlabs/stdlib', '4.1.0'
# supports puppetlabs/postgresql on ubuntu
mod 'puppetlabs/apt', '1.4.0'

## networking
mod 'attachmentgenie/ssh', '1.2.1'
mod 'netatalk',
	:git => 'git://github.com/jonoterc/puppet-netatalk.git'
mod 'samba',
	:git => 'git://github.com/ajjahn/puppet-samba.git'

## monitoring
mod 'example42/monit', '2.0.13'

## databases
mod 'puppetlabs/sqlite', '0.0.1'
mod 'puppetlabs/mysql', '2.1.0'
mod 'puppetlabs/postgresql', '3.2.0'

## webserver
# restore this once the package_ensure bugfix has been released on puppetforge
# mod 'puppetlabs/apache', '0.10.0'
mod 'apache',
	:git => "git://github.com/jonoterc/puppetlabs-apache.git",
	:ref => 'mod-passenger'

## rvm/ruby
# mod 'maestrodev/rvm', '1.2.0'
mod 'rvm',
	:git => "git://github.com/jonoterc/puppet-rvm.git",
	:ref => 'mod-passenger'

## version control
mod 'puppetlabs/vcsrepo', '0.2.0'

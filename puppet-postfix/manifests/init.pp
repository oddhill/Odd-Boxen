# Class for Postfix.

class postfix {

  include postfix::config

  file { $postfix::config::mainfile:
    content => template('postfix/main.cf.erb'),
    group   => 'wheel',
    owner   => 'root',
    notify  => Exec['restart postfix'],
  }

  exec { 'restart postfix' :
    command => 'postfix status && postfix stop && postfix start || postfix start',
    cwd => '/usr/sbin',
    user => 'root',
    refreshonly => true,
  }

}

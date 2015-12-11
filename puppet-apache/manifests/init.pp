class apache {

  include apache::config

  # Set path to configs
  $httpd_conf_template = 'apache/config/apache/httpd.conf.erb'
  $httpd_ssl_conf_template = 'apache/config/apache/httpd-ssl.conf.erb'

  # Add all the directories and files Apache is expecting
  # Most of these should already exist on Mountain Lion

  file { [
    $apache::config::configdir,
    $apache::config::logdir,
  ]:
    ensure => directory,
    owner  => root,
    group  => wheel,
  }

  file { [
    $apache::config::sitesdir,
    $apache::config::ssl_storage,
  ]:
    ensure => directory,
    owner  => $boxen_user,
    group  => staff,
  }

  file { $apache::config::configfile:
    content => template($httpd_conf_template),
    notify  => Service['org.apache.httpd'],
    owner   => root,
    group   => wheel
  }

  file { $apache::config::vhostsfile:
    content => template('apache/config/apache/httpd-vhosts.conf.erb'),
    notify  => Service['org.apache.httpd'],
    owner   => root,
    group   => wheel
  }

  file { $apache::config::ssl_file:
    content => template($httpd_ssl_conf_template),
    notify  => Service['org.apache.httpd'],
    owner   => root,
    group   => wheel
  }

  file { $apache::config::ssl_certificate_file:
    content => template('apache/ssl/dev.crt.erb'),
    notify  => Service['org.apache.httpd'],
    owner   => root,
    group   => wheel
  }

  file { $apache::config::ssl_certificate_key_file:
    content => template('apache/ssl/dev.key.erb'),
    notify  => Service['org.apache.httpd'],
    owner   => root,
    group   => wheel
  }

  # Service stuff

  file { '/Library/LaunchDaemons/dev.apache.plist':
    content => template('apache/dev.apache.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.apache'],
    owner   => 'root'
  }

  service { "org.apache.httpd":
    ensure => stopped
  }

  service { "dev.apache":
    ensure => running,
    require => File[$apache::config::configfile]
  }

}

class oddhill::implementation::lamp {
  include apache
  include wget
  include autoconf
  include libtool
  include pcre
  include libpng
  include imagemagick
  include mysql
  include solr
  include java
  include postfix
  include openssl

  # Install php
  $php_version = '5.4.41'

  php::version { $php_version:
    ensure => present
  }

  include php::composer

  class { 'php::global':
    version => $php_version
  }

  php::extension::mcrypt { "mcrypt for {$php_version}":
  	php => $php_version,
    require => Php::Version[$php_version]
  }

  php::extension::mongo { "mongo for {$php_version}":
  	php => $php_version,
    require => Php::Version[$php_version]
  }

  # Symlink pkg-config to usr/local, fixes https://github.com/oddhill/oddboxen/issues/617
  exec {'link_pkg-config':
    command => 'mkdir -p /usr/local/bin && ln -s /opt/boxen/homebrew/bin/pkg-config /usr/local/bin/pkg-config',
    creates => '/usr/local/bin/pkg-config',
    require => Class['pkgconfig'],
    user => root
  }

  php::extension::imagick { "imagick for {$php_version}":
    php => $php_version,
    version => '3.1.2',
    require => [Php::Version[$php_version], Exec['link_pkg-config']]
  }

  # Make sure php is not installed from homebrew
  package {
    'php53':
      ensure => 'absent';
    'php54':
      ensure => 'absent';
  }

  # Install drush
  class { 'drush':
    version => '7.0.0',
    require => Php::Version[$php_version]
  }

  drush::plugin {'drush-registry-rebuild':
    name => 'registry_rebuild'
  }

  drush::plugin {'drush-module-builder':
    name => 'module_builder'
  }
}

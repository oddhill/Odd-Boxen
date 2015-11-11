class oddhill::implementation::lamp {
  # Install ruby gems and node modules that
  # are used when developing with Drupal
  include oddhill::implementation::ruby_gems
  include oddhill::implementation::node_modules

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

  # Install curl
  package { 'curl':
    ensure => 'present',
    install_options => [
      '--with-openssl',
    ],
    require => Package['openssl'],
  }

  # Install libxml2
  package { 'libxml2':
    ensure => 'present',
  }

  # Install php
  $php_version = '5.5.9'

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

  # Symlink pkg-config to usr/local
  # fixes https://github.com/oddhill/oddboxen/issues/617
  file { ['/usr/local', '/usr/local/bin']:
    ensure => 'directory'
  }

  file { '/usr/local/bin/pkg-config':
    ensure => 'link',
    target => '/opt/boxen/homebrew/bin/pkg-config',
    require => [File['/usr/local/bin'], Class['pkgconfig']]
  }

  php::extension::imagick { "imagick for {$php_version}":
    php => $php_version,
    version => '3.1.2',
    require => [Php::Version[$php_version], File['/usr/local/bin/pkg-config']]
  }

  php::extension::xhprof { "xhprof for {$php_version}":
    php => $php_version,
    require => [Php::Version[$php_version]]
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
    version => '8.0.0-rc2',
    require => Php::Version[$php_version]
  }

  drush::plugin {'drush-registry-rebuild':
    name => 'registry_rebuild'
  }

  drush::plugin {'drush-module-builder':
    name => 'module_builder'
  }
}

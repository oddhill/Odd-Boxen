class oddhill::implementation::mean {
  include mongodb
  include heroku

  package { 'graphicsmagick':
    ensure => 'present'
  }
}

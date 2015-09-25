class projects::dev-apps {
  # Install some common-apps
  include brewcask
  package { 'sequel-pro': provider => 'brewcask' }
  package { 'tower': provider => 'brewcask' }
}

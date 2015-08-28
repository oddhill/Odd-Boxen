class projects::common-apps {
  # Install some common-apps
  include brewcask
  package { 'sequel-pro': provider => 'brewcask' }
  include tower
}

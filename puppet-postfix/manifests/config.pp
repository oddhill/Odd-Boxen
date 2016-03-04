# Config class for Postfix.

class postfix::config {

  include postfix::sendgrid

  $mainfile = '/etc/postfix/main.cf'

  # Send mail via Sendgrid. See the documentation at
  # https://sendgrid.com/docs/Integrate/Mail_Servers/postfix.html
  # for further information.

  $smtp_sasl_auth_enable = 'yes'
  $smtp_sasl_password_maps = "static:${postfix::sendgrid::username}:${postfix::sendgrid::password}"
  $smtp_sasl_security_options = 'noanonymous'
  $smtp_tls_security_level = 'encrypt'
  $header_size_limit = 4096000
  $relayhost = '[smtp.sendgrid.net]:587'

}

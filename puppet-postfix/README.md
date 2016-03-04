# Postfix Module for Boxen

A small module that configures Postfix for use with Sendgrid.

## Usage
Copy the manifests/sendgrid.pp.default to manifests/sendgrid.pp. Enter your Sendgrid credentials in the new file.

Then simply:

```include postfix```

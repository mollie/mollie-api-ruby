$:.push File.expand_path('../lib', __FILE__)

require 'mollie/api/client/version'

Gem::Specification.new do |s|
  s.name = 'mollie-api-ruby'
  s.version = Mollie::API::Client::VERSION
  s.summary = 'Official Mollie API Client for Ruby'
  s.description = %(Accepting iDEAL, Bancontact/Mister Cash, SOFORT Banking,
                  Creditcard, SEPA Bank transfer, SEPA Direct debit, Bitcoin,
                  PayPal, KBC Payment Button, CBC Payment Button, Belfius Direct
                  Net, paysafecard and PODIUM Cadeaukaart online payments without
                  fixed monthly costs or any punishing registration procedures.')
  s.authors = ['Mollie B.V.']
  s.email = ['info@mollie.nl']
  s.homepage = 'https://github.com/mollie/mollie-api-ruby'
  s.license = 'BSD'
  s.required_ruby_version = '>= 2.0.0'

  s.files = `git ls-files`.split("\n")
  s.test_files = Dir['test/**/*']

  s.add_development_dependency("rake")
  s.add_development_dependency("test-unit")
  s.add_development_dependency("webmock")
  s.add_development_dependency("thin")
  s.add_development_dependency("sinatra")
  s.add_development_dependency("sinatra-contrib")
  s.add_development_dependency("sinatra-cross_origin")
  s.add_development_dependency("rack-oauth2")
  s.add_development_dependency("swagger-blocks")
  s.add_development_dependency("ngrok-tunnel")
end

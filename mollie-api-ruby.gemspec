$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'mollie/version'

Gem::Specification.new do |s|
  s.name = 'mollie-api-ruby'
  s.version = Mollie::VERSION
  s.summary = 'Official Mollie API Client for Ruby'
  s.description = %(Accepting iDEAL, Bancontact/Mister Cash, SOFORT Banking,
                  Creditcard, SEPA Bank transfer, SEPA Direct debit, Bitcoin,
                  PayPal, KBC Payment Button, CBC Payment Button, Belfius Direct
                  Net, paysafecard, PODIUM Cadeaukaart and ING Home’Pay online payments without
                  fixed monthly costs or any punishing registration procedures.')
  s.authors = ['Mollie B.V.']
  s.email = ['info@mollie.nl']
  s.homepage = 'https://github.com/mollie/mollie-api-ruby'
  s.license = 'BSD'
  s.required_ruby_version = '>= 2.3.8'

  s.files = `git ls-files`.split("\n")
  s.test_files = Dir['test/**/*']

  s.add_development_dependency('rake')
  s.add_development_dependency('rubocop', '~> 0.57.2')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('webmock')
end

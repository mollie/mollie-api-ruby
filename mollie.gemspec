$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'Mollie/API/Client'

spec = Gem::Specification.new do |s|
  s.name = 'mollie-api-ruby'
  s.version = Mollie::API::Client::CLIENT_VERSION
  s.summary = 'Official Mollie API Client for Ruby'
  s.description = 'Accepting iDEAL, Mister Cash, Creditcard, PayPal, and paysafecard online payments without fixed monthly costs or any punishing registration procedures.'
  s.authors = ['Rick Wong']
  s.email = ['info@mollie.nl']
  s.homepage = 'https://github.com/mollie/mollie-api-ruby'
  s.license = 'BSD'
  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency('rest-client', '~> 1.6')
  s.add_dependency('json', '~> 1.8')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
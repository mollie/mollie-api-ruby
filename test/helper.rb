require 'test/unit'
require 'webmock/test_unit'

require 'mollie'

Mollie::Client.configure do |config|
  config.api_key = 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
end

def read_fixture(path)
  File.read(File.join(File.dirname(__FILE__), 'fixtures', path))
end

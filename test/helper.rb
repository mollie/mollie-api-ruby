require 'test/unit'
require 'webmock/test_unit'

require 'mollie'

Mollie::Client.configure do |config|
  config.api_key = "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM"
end

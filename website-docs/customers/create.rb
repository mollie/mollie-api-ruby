require 'mollie-api-ruby'

begin
  customer = Mollie::Customer.create(
    name:     "John",
    email:    "john@example.com",
    locale:   "en_US",
    api_key:  'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

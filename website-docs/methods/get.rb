require 'mollie-api-ruby'

begin
  method = Mollie::Method.get(
    "ideal",
    include: 'issuers',
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

require 'mollie-api-ruby'

begin
  limit     = 50
  issuers = Mollie::Issuer.all(
    limit: limit,
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

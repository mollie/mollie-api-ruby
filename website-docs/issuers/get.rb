require 'mollie-api-ruby'

begin
  issuer = Mollie::Issuer.get(
    "ideal_ABNANL2A",
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

require 'mollie-api-ruby'

begin
  mandate = Mollie::Mandate.get(
    "mdt_pWUnw6pkBN",
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

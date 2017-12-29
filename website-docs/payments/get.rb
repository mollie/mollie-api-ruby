require 'mollie-api-ruby'

begin
  payment = Mollie::Payment.get(
    "tr_7UhSN1zuXS",
    api_key:  'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

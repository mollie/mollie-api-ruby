require 'mollie-api-ruby'

begin
  invoice = Mollie::Invoice.get(
    "inv_xBEbP9rvAq",
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

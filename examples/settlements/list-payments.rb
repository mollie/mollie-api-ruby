require 'mollie-api-ruby'

begin
  limit    = 50
  payments = Mollie::Settlement::Payment.all(
    limit:         limit,
    settlement_id: "stl_jDk30akdN",
    api_key:       'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

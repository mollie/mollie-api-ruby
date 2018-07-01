require 'mollie-api-ruby'

begin
  limit       = 50
  chargebacks = Mollie::Settlement::Chargeback.all(
    limit:         limit,
    settlement_id: "stl_jDk30akdN",
    api_key:       'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

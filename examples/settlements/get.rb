require 'mollie-api-ruby'

begin
  settlement = Mollie::Settlement.get(
    "stl_jDk30akdN",
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

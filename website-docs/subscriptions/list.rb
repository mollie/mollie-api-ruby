require 'mollie-api-ruby'

begin
  offset        = 0
  limit         = 50
  subscriptions = Mollie::Subscription.all(
    offset, limit,
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

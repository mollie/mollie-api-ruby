require 'mollie-api-ruby'

begin
  Mollie::Subscription.delete(
    "sub_rVKGtNd6s3",
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

require 'mollie-api-ruby'

begin
  subscription = Mollie::Subscription.get(
    "sub_rVKGtNd6s3",
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

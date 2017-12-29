require 'mollie-api-ruby'

begin
  subscription = Mollie::Customer::Subscription.create(
    amount:      "20.00",
    times:       4,
    interval:    "3 months",
    description: "Quarterly payment",
    webhook_url: "https://webshop.example.org/payments/webhook/",
    api_key:     'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

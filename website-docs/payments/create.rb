require 'mollie-api-ruby'

begin
  payment = Mollie::Payment.create(
    amount:      { value: '10.0', currency: 'EUR' },
    description: 'My first payment',
    redirectUrl: 'https://webshop.example.org/order/12345/',
    webhookUrl:  'https://webshop.example.org/payments/webhook/',
    metadata:    {
      order_id: '12345'
    },
    api_key:     'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

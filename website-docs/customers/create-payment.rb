require 'mollie-api-ruby'

begin
  payment = Mollie::Customer::Payment.create(
    customer_id:  'cst_8wmqcHMN4U',
    amount:       { value: '10.0', currency: 'EUR' },
    description:  'First payment',
    redirect_url: 'https://webshop.example.org/order/12345/',
    api_key:      'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

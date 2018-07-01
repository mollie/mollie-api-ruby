require 'mollie-api-ruby'

begin
  methods = Mollie::Method.all(
    amount: { value: '100.00', currency: 'EUR' },
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

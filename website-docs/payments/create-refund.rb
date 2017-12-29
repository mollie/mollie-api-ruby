require 'mollie-api-ruby'

begin
  refund = Mollie::Payment::Refund.create(
    payment_id:  'tr_7UhSN1zuXS',
    amount:      '5.0',
    description: 'Did not like it',
    api_key:     'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end



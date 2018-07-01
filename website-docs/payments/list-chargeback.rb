require 'mollie-api-ruby'

begin
  limit       = 50
  chargebacks = Mollie::Payment::Chargeback.all(
    limit: limit,
    payment_id: 'tr_7UhSN1zuXS',
    api_key:    'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

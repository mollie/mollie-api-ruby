require 'mollie-api-ruby'

begin
  offset  = 0
  limit   = 50
  refunds = Mollie::Payment::Refund.all(
    offset, limit,
    payment_id: 'tr_7UhSN1zuXS',
    api_key:    'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

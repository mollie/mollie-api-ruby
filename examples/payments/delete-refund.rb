require 'mollie-api-ruby'

begin
  Mollie::Payment::Refund.delete(
    're_4qqhO89gsT',
    payment_id: 'tr_7UhSN1zuXS',
    api_key:    'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end



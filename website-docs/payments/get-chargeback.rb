require 'mollie-api-ruby'

begin
  chargeback = Mollie::Payment::Chargeback.get(
    "chb_n9z0tp",
    payment_id: "tr_7UhSN1zuXS",
    api_key:    'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

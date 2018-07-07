require 'mollie-api-ruby'

begin
  mandate = Mollie::Mandate.create(
    customer_id:       "cst_8wmqcHMN4U",
    method:            "directdebit",
    consumer_name:     "John",
    consumer_account:  "NL53INGB0000000000",
    consumer_bic:      "INGBNL2A",
    signature_date:    "2016-05-01",
    mandate_reference: "ref-123",
    api_key:           'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

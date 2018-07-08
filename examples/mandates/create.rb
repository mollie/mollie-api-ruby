mandate = Mollie::Customer::Mandate.create(
  customer_id:       "cst_4qqhO89gsT",
  method:            "directdebit",
  consumer_name:     "John Doe",
  consumer_account:  "NL55INGB0000000000",
  consumer_bic:      "INGBNL2A",
  signature_date:    "2018-05-07",
  mandate_reference: "YOUR-COMPANY-MD13804",
)

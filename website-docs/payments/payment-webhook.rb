require 'mollie-api-ruby'

begin
  payment = Mollie::Payment.get(
      "tr_7UhSN1zuXS",
      api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )

  if payment.paid?
    #
    # At this point you'd probably want to start the process of delivering the
    # product to the customer.
    #
  elsif !payment.open?
    #
    # The payment isn't paid and isn't open anymore. We can assume it was aborted.
    #
  end
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end
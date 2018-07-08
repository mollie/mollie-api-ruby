payment = Mollie::Payment.get("tr_7UhSN1zuXS")

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

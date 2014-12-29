#
# Example 7 - How to refund a payment programmatically.
#
require File.expand_path "../lib/Mollie/API/Client", File.dirname(__FILE__)

begin
  #
  # Initialize the Mollie API library with your API key.
  #
  # See: https://www.mollie.nl/beheer/account/profielen/
  #
  mollie = Mollie::API::Client.new
  mollie.setApiKey "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM"

  #
  # Retrieve the payment you want to refund from the API.
  #
  payment = mollie.payments.get "tr_47uEE1su8q"

  #
  # Refund the payment.
  #
  refund = mollie.payments_refunds.with(payment).create

  $response.body << "The payment #{payment.id} is now refunded.<br>"

  #
  # Retrieve refunds on a payment.
  #
  refunds = mollie.payments_refunds.with(payment).all

  refunds.each { |refund|
    $response.body << '<br> Refund date: ' << (CGI.escapeHTML refund.refundedDatetime)
    $response.body << '<br> Refunded: &euro; ' << (CGI.escapeHTML refund.amountRefunded)
    $response.body << '<br> Remaining: &euro; ' << (CGI.escapeHTML refund.amountRemaining)
    $response.body << '<br>'
  }
rescue Mollie::API::Exception => e
  $response.body << "API call failed: " << (CGI.escapeHTML e.message)
end

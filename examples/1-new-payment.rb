#
# Example 1 - How to prepare a new payment with the Mollie API.
#
require File.expand_path "../lib/mollie/api/client", File.dirname(__FILE__)

begin
  #
  # Initialize the Mollie API library with your API key.
  #
  # See: https://www.mollie.nl/beheer/account/profielen/
  #
  mollie = Mollie::API::Client.new
  mollie.api_key =  "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM"

  #
  # Generate a unique order id for this example. It is important to include this unique attribute
  # in the redirectUrl (below) so a proper return page can be shown to the customer.
  #
  order_id = Time.now.to_i

  #
  # Determine the url parts to these example files.
  #
  protocol = $request.secure? && "https" || "http"
  hostname = $request.host || "localhost"
  port     = $request.port || 80
  path     = $request.script_name || ""

  #
  # Payment parameters:
  #   amount        Amount in EUROs. This example creates a € 10,- payment.
  #   description   Description of the payment.
  #   redirectUrl   Redirect location. The customer will be redirected there after the payment.
  #   metadata      Custom metadata that is stored with the payment.
  #
  payment = mollie.payments.create \
    :amount       => 10.00,
    :description  => "My first API payment",
    :redirect_url  => "#{protocol}://#{hostname}:#{port}#{path}/3-return-page?order_id=#{order_id}",
    :metadata     => {
      :order_id => order_id
    }
  #
  # In this example we store the order with its payment status in a database.
  #
  database_write order_id, payment.status

  #
  # Send the customer off to complete the payment.
  #
  $response.redirect payment.payment_url
rescue Mollie::API::Exception => e
  $response.body << "API call failed: " << (CGI.escapeHTML e.message)
end

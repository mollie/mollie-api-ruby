#
# Example 2 - How to verify Mollie API Payments in a webhook.
#
require File.expand_path "../lib/Mollie/API/Client", __dir__

begin 
	#
	# Initialize the Mollie API library with your API key.
	#
	# See: https://www.mollie.nl/beheer/account/profielen/
	#
	mollie = Mollie::API::Client.new
	mollie.setApiKey "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM"

	#
	# Retrieve the payment's current state.
	#
	payment  = mollie.payments.get $request.params['id']
	order_id = payment.metadata.order_id

	#
	# Update the order in the database.
	#
	database_write order_id, payment.status

	if payment.paid?
		#
		# At this point you'd probably want to start the process of delivering the product to the customer.
		#
		$response.body << "Paid"
	elsif payment.open? == false
		#
		# The payment isn't paid and isn't open anymore. We can assume it was aborted.
		#
		$response.body << "Cancelled"
	else
		$response.body << "In progress"
	end
rescue Mollie::API::Exception => e
	$response.body << "API call failed: " << (CGI.escapeHTML e.message)
end

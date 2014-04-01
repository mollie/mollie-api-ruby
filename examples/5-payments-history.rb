#
# Example 5 - How to retrieve your payments history.
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
	# Get the all payments for this API key ordered by newest.
	#
	payments = mollie.payments.all

	$response.body = "Your API key has #{payments.totalCount} payments, last #{payments.count}:<br>"

	payments.each { |payment| 
		$response.body << "&euro; #{payment.amount}, status: #{CGI.escapeHTML payment.status} (#{CGI.escapeHTML payment.id})<br>"
	}
rescue Mollie::API::Exception => e
	$response.body << "API call failed: " << (CGI.escapeHTML e.message)
end

#
# Example 4 - How to prepare an iDEAL payment with the Mollie API.
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
	# First, let the customer pick the bank in a simple HTML form. This step is actually optional.
	#
	if $request.params.empty?
		issuers = mollie.issuers.all

		$response.body << '<form method="post">Select your bank: <select name="issuer">'

		issuers.each { |issuer| 
			if issuer.method == Mollie::API::Object::Method::IDEAL
				$response.body << '<option value=' << (CGI.escapeHTML issuer.id) << '>' << (CGI.escapeHTML issuer.name)
			end
		}

		$response.body <<  '<option value="">or select later</option>'
		$response.body <<  '</select><button>OK</button></form>'
	else
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
		#   amount        Amount in EUROs. This example creates a € 27,50 payment.
		#   description   Description of the payment.
		#   redirectUrl   Redirect location. The customer will be redirected there after the payment.
		#   metadata      Custom metadata that is stored with the payment.
	 	#   method        Payment method "ideal".
	 	#   issuer        The customer's bank. If empty the customer can select it later.
		#
		payment = mollie.payments.create \
			:amount       => 27.50,
			:description  => "My first API payment",
			:redirectUrl  => "#{protocol}://#{hostname}:#{port}#{path}/3-return-page?order_id=#{order_id}",
			:metadata     => {
				:order_id => order_id
			},
			:method       => Mollie::API::Object::Method::IDEAL,
			:issuer       => !$request.params['issuer'].empty? ? $request.params['issuer'] : nil
		
		#
		# In this example we store the order with its payment status in a database.
		#
		database_write order_id, payment.status

		#
		# Send the customer off to complete the payment.
		#
		$response.redirect payment.getPaymentUrl
	end
rescue Mollie::API::Exception => e
	$response.body << "API call failed: " << (CGI.escapeHTML e.message)
end

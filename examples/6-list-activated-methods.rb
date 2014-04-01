#
# Example 6 - How to get the currently activated payment methods.
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
	# Get the all the activated methods for this API key.
	#
	methods = mollie.methods.all

	$response.body << "Your API key has #{methods.totalCount} activated payment methods:<br>"

	methods.each { |method|
		$response.body << '<div style="line-height:40px; vertical-align:top">'
		$response.body << '<img src="' << (CGI.escapeHTML method.image.normal) << '"> '
		$response.body << (CGI.escapeHTML method.description) << ' (' << (CGI.escapeHTML method.id) << ')'
		$response.body << '</div>'
	}
rescue Mollie::API::Exception => e
	$response.body << "API call failed: " << (CGI.escapeHTML e.message)
end

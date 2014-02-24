#
# Example 3 - How to show a return page to the customer.
#
# In this example we retrieve the order stored in the database.
# Here, it's unnecessary to use the Mollie API Client.
#
if $request.params.empty?
	$response.body << "No order"
else
	status = database_read $request.params['order_id']

	#
	# Determine the url parts to these example files.
	#
	path = $request.script_name || ""

	$response.body << "<p>Your payment status is '" << (CGI.escapeHTML status) << "'.</p>"
	$response.body << "<p>"
	$response.body << '<a href="' << path << '/">Back to examples</a><br>'
	$response.body << "</p>"
end
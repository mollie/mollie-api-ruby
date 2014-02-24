require 'sinatra'

#
# Show all examples as links.
#
examples = [
	'1-new-payment',
	'2-webhook-verification',
	'3-return-page',
	'4-ideal-payment',
	'5-payments-history',
	'6-list-activated-methods'
]

get "/" do
	index = ""

	examples.each { |example|
		index << "<a href='/#{example}'>#{example}</a><br>"
	}

	index
end

#
# Register all examples as pages.
#
examples.each { |example|
	get "/#{example}" do
		$request  = request
		$response = response
		load File.expand_path "#{example}.rb", __dir__
	end

	post "/#{example}" do
		$request  = request
		$response = response
		load File.expand_path "#{example}.rb", __dir__
	end
}

#
# NOTE: This example uses a text file as a database. Please use a real database like MySQL in production code.
#
def database_write (order_id, status)
	order_id = order_id.to_i
	database = File.expand_path "orders/order-#{order_id}.txt", __dir__

	File.open(database, 'w') { |file| file.write status }
end

def database_read (order_id)
	order_id = order_id.to_i
	database = File.expand_path "orders/order-#{order_id}.txt", __dir__

	status = File.read(database) || "unknown order"
end
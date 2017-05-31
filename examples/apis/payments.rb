class Application < Sinatra::Application
  swagger_schema :PaymentRequest do
    property :amount, type: :decimal, description: 'Amount of money', example: 10.0
    property :description, type: :string, description: 'Description', example: "My first payment"
    property :redirect_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/order/12345/"
    property :webhook_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/payments/webhook/"
    property :metadata, type: :object, description: 'Extra info', example: { "order_id" => "12345" }
  end

  swagger_path '/v1/payments' do
    operation :get, description: 'List payments', tags: ['Payments'] do
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/payments' do
    operation :post, description: 'Create payment', tags: ['Payments'] do
      security api_key: []
      parameter name: :payment, in: 'body', description: 'PaymentRequest params', schema: { '$ref' => '#/definitions/PaymentRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/payments/{id}' do
    operation :get, description: 'Get payment', tags: ['Payments'] do
      parameter name: :id, in: 'path', description: 'Payment id', type: :string
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/payments' do
    payments = client.payments.all
    JSON.pretty_generate(payments.attributes)
  end

  get '/v1/payments/:id' do
    payment = client.payments.get(params[:id])
    JSON.pretty_generate(payment.attributes)
  end

  post '/v1/payments' do
    payment     = client.payments.create(
        amount:       json_params['amount'],
        description:  json_params['description'],
        redirect_url: json_params['redirect_url'],
        webhook_url:  json_params['webhook_url'],
        metadata:     json_params['metadata'],
    )
    JSON.pretty_generate(payment.attributes)
  end
end

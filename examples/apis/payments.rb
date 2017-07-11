class Application < Sinatra::Application
  swagger_schema :PaymentRequest do
    property :amount, type: :decimal, description: 'Amount of money', example: 10.0
    property :description, type: :string, description: 'Description', example: "My first payment"
    property :redirect_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/order/12345/"
    property :webhook_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/payments/webhook/"
    property :metadata, type: :object, description: 'Extra info', example: { "order_id" => "12345" }
    property :profileId, type: :object, description: 'ProfileId (Connect api only)', example: "pfl_FxPFwdxxJf"
    property :testmode, type: :boolean, description: '(Connect api only)', example: true
  end

  swagger_schema :RefundRequest do
    property :amount, type: :decimal, description: 'Amount of money', example: 10.0
    property :description, type: :string, description: 'Description', example: "My first payment"
    property :testmode, type: :boolean, description: 'Testmode', example: true
  end

  swagger_path '/v1/payments' do
    operation :post, description: 'Create payment https://www.mollie.com/en/docs/reference/payments/create', tags: ['Payments'] do
      security api_key: []
      parameter name: :payment, in: 'body', description: 'PaymentRequest params', schema: { '$ref' => '#/definitions/PaymentRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/payments/{id}' do
    operation :get, description: 'Get payment https://www.mollie.com/en/docs/reference/payments/get', tags: ['Payments'] do
      parameter name: :id, in: 'path', description: 'Payment id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/payments' do
    operation :get, description: 'List payments https://www.mollie.com/en/docs/reference/payments/list', tags: ['Payments'] do
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :profile_id, in: 'query', description: 'Profile ID', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/payments/{payment_id}/refunds' do
    operation :post, description: 'Create payment https://www.mollie.com/nl/docs/reference/refunds/create', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      security api_key: []
      parameter name: :refund, in: 'body', description: 'RefundRequest params', schema: { '$ref' => '#/definitions/RefundRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :get, description: 'List payment refunds https://www.mollie.com/en/docs/reference/refunds/list', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/payments/{payment_id}/refunds/{id}' do
    operation :get, description: 'Create payment https://www.mollie.com/nl/docs/reference/refunds/get', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      parameter name: :id, in: 'path', description: 'Refund id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :delete, description: 'Delete payment https://www.mollie.com/nl/docs/reference/refunds/delete', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      parameter name: :id, in: 'path', description: 'Refund id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 204, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/payments' do
    payments = client.payments.all(params[:offset], params[:count],
                                   profile_id: params[:profile_id],
                                   testmode:   params[:testmode]
    )

    JSON.pretty_generate(payments.attributes)
  end

  get '/v1/payments/:id' do
    payment = client.payments.get(params[:id], testmode: params[:testmode])
    JSON.pretty_generate(payment.attributes)
  end

  post '/v1/payments' do
    payment = client.payments.create(
      amount:       json_params['amount'],
      description:  json_params['description'],
      redirect_url: json_params['redirect_url'],
      webhook_url:  json_params['webhook_url'],
      metadata:     json_params['metadata'],
      profileId:    json_params['profileId'],
      testmode:     json_params['testmode'],
    )
    JSON.pretty_generate(payment.attributes)
  end

  post '/v1/payments/:payment_id/refunds' do
    refund = client.payments_refunds.with(params[:payment_id]).create(
      amount:      json_params['amount'],
      description: json_params['description'],
      testmode:    json_params['testmode']
    )
    JSON.pretty_generate(refund.attributes)
  end

  get '/v1/payments/:payment_id/refunds/:id' do
    refund = client.payments_refunds.with(params[:payment_id]).get(params[:id], testmode: params[:testmode])
    JSON.pretty_generate(refund.attributes)
  end

  delete '/v1/payments/:payment_id/refunds/:id' do
    client.payments_refunds.with(params[:payment_id]).delete(params[:id], testmode: params[:testmode])
    "deleted"
  end

  get '/v1/payments/:payment_id/refunds' do
    refunds = client.payments_refunds.with(params[:payment_id]).all(params[:offset], params[:count], testmode: params[:testmode])
    JSON.pretty_generate(refunds.attributes)
  end

end

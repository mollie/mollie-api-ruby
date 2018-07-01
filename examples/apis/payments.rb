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

  swagger_path '/v2/payments' do
    operation :post, description: 'Create payment https://www.mollie.com/en/docs/reference/payments/create', tags: ['Payments'] do
      security api_key: []
      parameter name: :payment, in: 'body', description: 'PaymentRequest params', schema: { '$ref' => '#/definitions/PaymentRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/payments/{id}' do
    operation :get, description: 'Get payment https://www.mollie.com/en/docs/reference/payments/get', tags: ['Payments'] do
      parameter name: :id, in: 'path', description: 'Payment id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/payments' do
    operation :get, description: 'List payments https://www.mollie.com/en/docs/reference/payments/list', tags: ['Payments'] do
      parameter name: :profile_id, in: 'query', description: 'Profile ID', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/payments/{payment_id}/refunds' do
    operation :post, description: 'Create payment https://www.mollie.com/nl/docs/reference/refunds/create', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      security api_key: []
      parameter name: :refund, in: 'body', description: 'RefundRequest params', schema: { '$ref' => '#/definitions/RefundRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :get, description: 'List payment refunds https://www.mollie.com/en/docs/reference/refunds/list', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/payments/{payment_id}/refunds/{id}' do
    operation :get, description: 'Get refund https://www.mollie.com/nl/docs/reference/refunds/get', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      parameter name: :id, in: 'path', description: 'Refund id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :delete, description: 'Delete refund https://www.mollie.com/nl/docs/reference/refunds/delete', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      parameter name: :id, in: 'path', description: 'Refund id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 204, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/payments/{payment_id}/chargebacks' do
    operation :get, description: 'List payment chargebacks https://www.mollie.com/en/docs/reference/chargebacks/list', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/payments/{payment_id}/chargebacks/{id}' do
    operation :get, description: 'Get chargeback https://www.mollie.com/nl/docs/reference/chargebacks/get', tags: ['Payments'] do
      parameter name: :payment_id, in: 'path', description: 'Payment id', type: :string
      parameter name: :id, in: 'path', description: 'Refund id', type: :string
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v2/payments' do
    payments = Mollie::Payment.all(profile_id: params[:profile_id],
                                   testmode:   params[:testmode]
    )

    JSON.pretty_generate(payments.attributes)
  end

  get '/v2/payments/:id' do
    payment = Mollie::Payment.get(params[:id], testmode: params[:testmode])

    JSON.pretty_generate(payment.attributes)
  end

  post '/v2/payments' do
    payment = Mollie::Payment.create(
      amount:       { value: json_params['amount'], currency: json_params["currency"] },
      description:  json_params['description'],
      redirect_url: json_params['redirect_url'],
      webhook_url:  json_params['webhook_url'],
      metadata:     json_params['metadata'],
      profileId:    json_params['profileId'],
      testmode:     json_params['testmode'],
    )
    JSON.pretty_generate(payment.attributes)
  end

  post '/v2/payments/:payment_id/refunds' do
    refund = Mollie::Payment::Refund.create(
      payment_id:  params[:payment_id],
      amount:      { value: json_params['amount'], currency: json_params["currency"] },
      description: json_params['description'],
      testmode:    json_params['testmode']
    )
    JSON.pretty_generate(refund.attributes)
  end

  get '/v2/payments/:payment_id/refunds/:id' do
    refund = Mollie::Payment::Refund.get(params[:id], testmode: params[:testmode], payment_id: params[:payment_id])
    JSON.pretty_generate(refund.attributes)
  end

  delete '/v2/payments/:payment_id/refunds/:id' do
    Mollie::Payment::Refund.delete(params[:id], testmode: params[:testmode], payment_id: params[:payment_id])
    "deleted"
  end

  get '/v2/payments/:payment_id/refunds' do
    refunds = Mollie::Payment::Refund.all(testmode: params[:testmode], payment_id: params[:payment_id])
    JSON.pretty_generate(refunds.attributes)
  end

  get '/v2/payments/:payment_id/chargebacks/:id' do
    chargeback = Mollie::Payment::Chargeback.get(params[:id], testmode: params[:testmode], payment_id: params[:payment_id])
    JSON.pretty_generate(chargeback.attributes)
  end

  get '/v2/payments/:payment_id/chargebacks' do
    chargebacks = Mollie::Payment::Chargeback.all(testmode: params[:testmode], payment_id: params[:payment_id])
    JSON.pretty_generate(chargebacks.attributes)
  end

end

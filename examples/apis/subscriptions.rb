class Application < Sinatra::Application
  swagger_schema :FirstPaymentRequest do
    property :amount, type: :decimal, description: 'Amount of money', example: 0.01
    property :currency, type: :string, description: 'Currency', example: 'EUR'
    property :customer_id, type: :string, description: 'Customer id', example: "cst_GUvJFqwVCD"
    property :description, type: :string, description: 'Description', example: "My first payment"
    property :recurring_type, type: :string, description: 'Recurring type', example: "first"
    property :redirect_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/order/12345/"
    property :webhook_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/payments/webhook/"
    property :metadata, type: :object, description: 'Extra info', example: { "order_id" => "12345" }
    property :testmode, type: :boolean, description: '(Connect api only)', example: true
  end

  swagger_schema :OnDemandPaymentRequest do
    property :amount, type: :decimal, description: 'Amount of money', example: 25.0
    property :currency, type: :string, description: 'Currency', example: 'EUR'
    property :customer_id, type: :string, description: 'Customer id', example: "cst_GUvJFqwVCD"
    property :description, type: :string, description: 'Description', example: "Monthly payment"
    property :recurring_type, type: :string, description: 'Recurring type', example: "recurring"
    property :redirect_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/order/12345/"
    property :webhook_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/payments/webhook/"
    property :metadata, type: :object, description: 'Extra info', example: { "order_id" => "12345" }
    property :testmode, type: :boolean, description: '(Connect api only)', example: true
  end

  swagger_schema :SubscriptionRequest do
    property :amount, type: :decimal, description: 'Amount of money', example: 25.0
    property :currency, type: :string, description: 'Currency', example: 'EUR'
    property :times, type: :integer, description: 'Times', example: "10"
    property :interval, type: :string, description: 'Interval', example: "1 month"
    property :start_date, type: :string, description: 'Start date', example: Time.now.strftime("%Y-%m-%d")
    property :description, type: :string, description: 'Description', example: "Monthly subscription"
    property :method, type: :object, description: 'Method', example: "directdebit"
    property :webhook_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/payments/webhook/"
    property :testmode, type: :boolean, description: '(Connect api only)', example: true
  end

  swagger_path '/v2/subscriptions/first_payment' do
    operation :post, description: 'https://www.mollie.com/en/docs/recurring#first-payment', tags: ['Subscriptions'] do
      security api_key: []
      parameter name: :payment, in: 'body', description: 'PaymentRequest params', schema: { '$ref' => '#/definitions/OnDemandPaymentRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/subscriptions/mandates/{customer_id}' do
    operation :get, description: 'List mandates', tags: ['Subscriptions'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/subscriptions/on_demand' do
    operation :post, description: 'https://www.mollie.com/en/docs/recurring#on-demand', tags: ['Subscriptions'] do
      parameter name: :payment, in: 'body', description: 'PaymentRequest params', schema: { '$ref' => '#/definitions/OnDemandPaymentRequest' }
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/customers/{customer_id}/subscriptions' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/subscriptions/get', tags: ['Subscriptions'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :post, description: 'https://www.mollie.com/en/docs/recurring#subscriptions', tags: ['Subscriptions'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      parameter name: :payment, in: 'body', description: 'PaymentRequest params', schema: { '$ref' => '#/definitions/SubscriptionRequest' }
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/customers/{customer_id}/subscriptions/{id}' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/subscriptions/get', tags: ['Subscriptions'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      parameter name: :id, in: 'path', description: 'Subscription id', type: :string, default: 'sub_qte7Jyfc5B'
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
    operation :delete, description: 'https://www.mollie.com/en/docs/reference/subscriptions/delete', tags: ['Subscriptions'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      parameter name: :id, in: 'path', description: 'Subscription id', type: :string, default: 'sub_qte7Jyfc5B'
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  post '/v2/subscriptions/first_payment' do
    payment = Mollie::Payment.create(
      amount:         { value: json_params['amount'], currency: json_params["currency"] },
      customer_id:    json_params['customer_id'],
      description:    json_params['description'],
      redirect_url:   json_params['redirect_url'],
      recurring_type: "first",
      webhook_url:    json_params['webhook_url'],
      metadata:       json_params['metadata'],
      testmode:       json_params['testmode'],
    )
    JSON.pretty_generate(payment.attributes)
  end

  get '/v2/subscriptions/mandates/:customer_id' do
    mandates = Mollie::Customer::Mandates.all(customer_id: params[:customer_id])
    JSON.pretty_generate(mandates.attributes)
  end

  post '/v2/subscriptions/on_demand' do
    payment = Mollie::Payment.create(
      amount:         { value: json_params['amount'], currency: json_params["currency"] },
      customer_id:    json_params['customer_id'],
      description:    json_params['description'],
      redirect_url:   json_params['redirect_url'],
      recurring_type: "recurring",
      webhook_url:    json_params['webhook_url'],
      metadata:       json_params['metadata'],
      testmode:       json_params['testmode'],
    )
    JSON.pretty_generate(payment.attributes)
  end

  get '/v2/customers/:customer_id/subscriptions' do
    subscriptions = Mollie::Customer::Subscription.all(testmode: params[:testmode], customer_id: params[:customer_id])
    JSON.pretty_generate(subscriptions.attributes)
  end

  get '/v2/customers/:customer_id/subscriptions/:id' do
    payment = Mollie::Customer::Subscription.get(params[:id], testmode: params[:testmode], customer_id: params[:customer_id])
    JSON.pretty_generate(payment.attributes)
  end

  post '/v2/customers/:customer_id/subscriptions' do
    subscription = Mollie::Customer::Subscription.create(
      amount:      { value: json_params['amount'], currency: json_params["currency"] },
      times:       json_params['times'],
      interval:    json_params['interval'],
      start_date:  json_params['start_date'],
      description: json_params["description"],
      method:      json_params['method'],
      webhook_url: json_params['webhook_url'],
      testmode:    json_params['testmode'],
    )
    JSON.pretty_generate(subscription.attributes)
  end

  delete '/v2/customers/:customer_id/subscriptions/:id' do
    Mollie::Customer::Subscription.delete(params[:id], testmode: params[:testmode], customer_id: params[:customer_id])
    "deleted"
  end
end

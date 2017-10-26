class Application < Sinatra::Application
  swagger_schema :CustomerRequest do
    property :name, type: :string, description: 'Name', example: "John doe"
    property :email, type: :string, description: 'Email', example: "john@example.com"
    property :locale, type: :string, description: 'locale', example: "en_US"
    property :metadata, type: :object, description: 'Metadata', example: { "user_id" => "12345" }
    property :profileId, type: :object, description: 'ProfileId (Connect api only)', example: "pfl_FxPFwdxxJf"
    property :testmode, type: :boolean, description: '(Connect api only)', example: true
  end

  swagger_path '/v1/customers' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/customers/list', tags: ['Customers'] do
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :testmode, in: 'query', type: :boolean, description: '(Connect api only)', example: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/customers' do
    operation :post, description: 'https://www.mollie.com/en/docs/reference/customers/create', tags: ['Customers'] do
      security api_key: []
      parameter name: :customer, in: 'body', description: 'CustomerRequest params', schema: { '$ref' => '#/definitions/CustomerRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/customers/{id}' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/customers/get', tags: ['Customers'] do
      parameter name: :id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      parameter name: :testmode, in: 'query', type: :boolean, description: '(Connect api only)', example: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
    operation :patch, description: 'https://www.mollie.com/en/docs/reference/customers/create', tags: ['Customers'] do
      parameter name: :id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      security api_key: []
      parameter name: :customer, in: 'body', description: 'CustomerRequest params', schema: { '$ref' => '#/definitions/CustomerRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/customers/{customer_id}/payments' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/customers/list-payments', tags: ['Customers'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      parameter name: :testmode, in: 'query', type: :boolean, description: '(Connect api only)', example: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :post, description: 'https://www.mollie.com/en/docs/reference/customers/create-payment', tags: ['Customers'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: 'cst_GUvJFqwVCD'
      parameter name: :payment, in: 'body', description: 'PaymentRequest params', schema: { '$ref' => '#/definitions/PaymentRequest' }
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/customers' do
    customers = Mollie::Customer.all(params[:offset], params[:count], testmode: params[:testmode])
    JSON.pretty_generate(customers.attributes)
  end

  get '/v1/customers/:id' do
    customer = Mollie::Customer.get(params[:id], testmode: params[:testmode])
    JSON.pretty_generate(customer.attributes)
  end

  post '/v1/customers' do
    customer = Mollie::Customer.create(
      name:      json_params['name'],
      email:     json_params['email'],
      locale:    json_params['locale'],
      metadata:  json_params['metadata'],
      profileId: json_params['profileId'],
      testmode:  json_params['testmode']
    )
    JSON.pretty_generate(customer.attributes)
  end

  patch '/v1/customers/:id' do
    customer = Mollie::Customer.update(params[:id],
                                       name:     json_params['name'],
                                       email:    json_params['email'],
                                       locale:   json_params['locale'],
                                       metadata: json_params['metadata'],
    )
    JSON.pretty_generate(customer.attributes)
  end

  get '/v1/customers/:customer_id/payments' do
    payments = Mollie::Customer::Payment.all(customer_id: params[:customer_id], testmode: params[:testmode])
    JSON.pretty_generate(payments.attributes)
  end

  post '/v1/customers/:customer_id/payments' do
    payment = Mollie::Customer::Payment.create(
      customer_id:  params[:customer_id],
      amount:       json_params['amount'],
      description:  json_params['description'],
      redirect_url: json_params['redirect_url'],
      webhook_url:  json_params['webhook_url'],
      metadata:     json_params['metadata'],
      profileId:    json_params['profileId'],
      testmode:     json_params['testmode']
    )
    JSON.pretty_generate(payment.attributes)
  end
end

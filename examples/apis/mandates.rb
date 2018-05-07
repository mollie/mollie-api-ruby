class Application < Sinatra::Application
  swagger_schema :MandateRequest do
    property :method, type: :decimal, description: 'Method', example: "directdebit"
    property :consumer_name, type: :string, description: 'Consumer name', example: "Customer A"
    property :consumer_account, type: :string, description: 'Account number', example: "NL17RABO0213698412"
    property :consumer_bic, type: :string, description: 'BIC', example: "RABONL2U"
    property :signature_date, type: :string, description: 'Date mandate was signed', example: "2016-05-01"
    property :mandate_reference, type: :string, description: 'A custom reference', example: "YOUR-COMPANY-MD13804"
    property :webhook_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/payments/webhook/"
    property :testmode, type: :boolean, description: '(Connect api only)', example: true
  end

  swagger_path '/v2/customers/{customer_id}/mandates' do
    operation :post, description: 'Create mandates', tags: ['Mandates'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: "cst_GUvJFqwVCD"
      security api_key: []
      parameter name: :mandate, in: 'body', description: 'MandateRequest params', schema: { '$ref' => '#/definitions/MandateRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :get, description: 'List mandates', tags: ['Mandates'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: "cst_GUvJFqwVCD"
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/customers/{customer_id}/mandates/{id}' do
    operation :get, description: 'Get mandate', tags: ['Mandates'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: "cst_GUvJFqwVCD"
      parameter name: :id, in: 'path', description: 'Mandate id', type: :string, default: "mdt_qP7Qk6mgaz"
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :delete, description: 'Remove mandate', tags: ['Mandates'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: "cst_GUvJFqwVCD"
      parameter name: :id, in: 'path', description: 'Mandate id', type: :string, default: "mdt_qP7Qk6mgaz"
      parameter name: :testmode, in: 'query', description: 'Testmode', type: :boolean, default: true
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  post '/v2/customers/:customer_id/mandates' do
    mandate = Mollie::Customer::Mandate.create(
      customer_id:       params[:customer_id],
      method:            json_params['method'],
      consumer_name:     json_params['consumer_name'],
      consumer_account:  json_params['consumer_account'],
      consumer_bic:      json_params['consumer_bic'],
      signature_date:    json_params['signature_date'],
      mandate_reference: json_params['mandate_reference'],
      webhook_url:       json_params['webhook_url'],
      testmode:          json_params['testmode']
    )
    JSON.pretty_generate(mandate.attributes)
  end

  get '/v2/customers/:customer_id/mandates' do
    mandates = Mollie::Customer::Mandate.all(params[:offset], params[:count], testmode: params[:testmode], customer_id: params[:customer_id])
    JSON.pretty_generate(mandates.attributes)
  end


  get '/v2/customers/:customer_id/mandates/:id' do
    mandate = Mollie::Customer::Mandate.get(params[:id], testmode: params[:testmode], customer_id: params[:customer_id])
    JSON.pretty_generate(mandate.attributes)
  end

  delete '/v2/customers/:customer_id/mandates/:id' do
    Mollie::Customer::Mandate.delete(params[:id], testmode: params[:testmode], customer_id: params[:customer_id])
    "deleted"
  end
end

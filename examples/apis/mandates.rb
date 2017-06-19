class Application < Sinatra::Application
  swagger_schema :MandateRequest do
    property :method, type: :decimal, description: 'Method', example: "directdebit"
    property :consumer_name, type: :string, description: 'Consumer name', example: "Customer A"
    property :consumer_account, type: :string, description: 'Account number', example: "NL53INGB0000000000"
    property :consumer_bic, type: :string, description: 'BIC', example: "INGBNL2A"
    property :signature_date, type: :string, description: 'Date mandate was signed', example: "2016-05-01"
    property :mandate_reference, type: :string, description: 'A custom reference', example: "YOUR-COMPANY-MD13804"
    property :webhook_url, type: :string, description: 'URL for redirection', example: "https://webshop.example.org/payments/webhook/"
  end

  swagger_path '/v1/customers/{customer_id}/mandates' do
    operation :post, description: 'Create mandates', tags: ['Mandates'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: "cst_GUvJFqwVCD"
      security api_key: []
      parameter name: :mandate, in: 'body', description: 'MandateRequest params', schema: { '$ref' => '#/definitions/MandateRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :get, description: 'List mandates', tags: ['Mandates'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: "cst_GUvJFqwVCD"
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/customers/{customer_id}/mandates/{id}' do
    operation :get, description: 'Get mandate', tags: ['Mandates'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: "cst_GUvJFqwVCD"
      parameter name: :id, in: 'path', description: 'Mandate id', type: :string, default: "mdt_qP7Qk6mgaz"
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end

    operation :delete, description: 'Remove mandate', tags: ['Mandates'] do
      parameter name: :customer_id, in: 'path', description: 'Customer id', type: :string, default: "cst_GUvJFqwVCD"
      parameter name: :id, in: 'path', description: 'Mandate id', type: :string, default: "mdt_qP7Qk6mgaz"
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  post '/v1/customers/:customer_id/mandates' do
    mandate = client.customer_mandates.with(params[:customer_id]).create(
        method:            json_params['method'],
        consumer_name:     json_params['consumer_name'],
        consumer_account:  json_params['consumer_account'],
        consumer_bic:      json_params['consumer_bic'],
        signature_date:    json_params['signature_date'],
        mandate_reference: json_params['mandate_reference'],
        webhook_url:       json_params['webhook_url'],
    )
    JSON.pretty_generate(mandate.attributes)
  end

  get '/v1/customers/:customer_id/mandates' do
    mandates = client.customers_mandates.with(params[:customer_id]).all
    JSON.pretty_generate(mandates.attributes)
  end


  get '/v1/customers/:customer_id/mandates/:id' do
    mandate = client.customers_mandates.with(params[:customer_id]).get(params[:id])
    JSON.pretty_generate(mandate.attributes)
  end

  delete '/v1/customers/:customer_id/mandates/:id' do
    client.customers_mandates.with(params[:customer_id]).delete(params[:id])
    "deleted"
  end
end

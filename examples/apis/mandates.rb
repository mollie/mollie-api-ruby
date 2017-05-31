class Application < Sinatra::Application
  swagger_path '/v1/customers/{customer_id}/mandates' do
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

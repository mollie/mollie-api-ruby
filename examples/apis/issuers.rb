class Application < Sinatra::Application
  swagger_path '/v2/issuers' do
    operation :get, description: 'List issuers https://www.mollie.com/en/docs/reference/issuers/list', tags: ['Issuers'] do
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/issuers/{id}' do
    operation :get, description: 'Get issuer', tags: ['Issuers'] do
      parameter name: :id, in: 'path', description: 'Issuer id', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v2/issuers' do
    issuers = Mollie::Issuer.all(testmode: params[:testmode])
    JSON.pretty_generate(issuers.attributes)
  end

  get '/v2/issuers/:id' do
    issuer = Mollie::Issuer.get(params[:id], testmode: params[:testmode])
    JSON.pretty_generate(issuer.attributes)
  end
end

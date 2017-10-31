class Application < Sinatra::Application
  swagger_path '/v1/organizations/{id}' do
    operation :get, description: 'Get organization https://www.mollie.com/en/docs/reference/organizations/get', tags: ['Organizations'] do
      parameter name: :id, in: 'path', description: 'Organization id', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/organizations/:id' do
    organization = Mollie::Organization.get(params[:id], testmode: params[:testmode])
    JSON.pretty_generate(organization.attributes)
  end
end

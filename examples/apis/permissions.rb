class Application < Sinatra::Application
  swagger_path '/v2/permissions' do
    operation :get, description: 'List permissions https://www.mollie.com/en/docs/reference/permissions/list', tags: ['Permissions'] do
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/permissions/{id}' do
    operation :get, description: 'Get permission https://www.mollie.com/en/docs/reference/permissions/get', tags: ['Permissions'] do
      parameter name: :id, in: 'path', description: 'Permission id', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v2/permissions' do
    permissions = Mollie::Permission.all(testmode: params[:testmode])
    JSON.pretty_generate(permissions.attributes)
  end

  get '/v2/permissions/:id' do
    permission = Mollie::Permission.get(params[:id], testmode: params[:testmode])
    JSON.pretty_generate(permission.attributes)
  end
end

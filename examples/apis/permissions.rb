class Application < Sinatra::Application
  swagger_path '/v1/permissions' do
    operation :get, description: 'List permissions https://www.mollie.com/en/docs/reference/permissions/list', tags: ['Permissions'] do
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/permissions/{id}' do
    operation :get, description: 'Get permission https://www.mollie.com/en/docs/reference/permissions/get', tags: ['Permissions'] do
      parameter name: :id, in: 'path', description: 'Permission id', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/permissions' do
    permissions = client.permissions.all(params[:offset], params[:count], testmode: params[:testmode])
    JSON.pretty_generate(permissions.attributes)
  end

  get '/v1/permissions/:id' do
    permission = client.permissions.get(params[:id], testmode: params[:testmode])
    JSON.pretty_generate(permission.attributes)
  end
end

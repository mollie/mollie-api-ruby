class Application < Sinatra::Application
  swagger_path '/v1/methods' do
    operation :get, description: 'List methods https://www.mollie.com/en/docs/reference/methods/list', tags: ['Methods'] do
      parameter name: :include, in: 'query', description: 'Include additional data, e.g. issuers', type: :string
      parameter name: :recurring_type, in: 'query', description: 'Recurring type', type: :string, default: 'first'
      parameter name: :locale, in: 'query', description: 'Locale', type: :integer
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :profile_id, in: 'query', description: 'Profile ID', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/methods/{id}' do
    operation :get, description: 'Get method', tags: ['Methods'] do
      parameter name: :id, in: 'path', description: 'Method id', type: :string
      parameter name: :include, in: 'query', description: 'Include additional data, e.g. issuers', type: :string
      parameter name: :locale, in: 'query', description: 'Locale', type: :integer
      parameter name: :profile_id, in: 'query', description: 'Profile ID', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/methods' do
    methods = client.methods.all(params[:offset], params[:count],
                                 include:        params[:include],
                                 recurring_type: params[:recurring_type],
                                 locale:         params[:locale],
                                 profile_id:     params[:profile_id],
                                 testmode:       params[:testmode]
    )
    JSON.pretty_generate(methods.attributes)
  end

  get '/v1/methods/:id' do
    method = client.methods.get(params[:id],
                                include:    params[:include],
                                locale:     params[:locale],
                                profile_id: params[:profile_id],
                                testmode:   params[:testmode]
    )
    JSON.pretty_generate(method.attributes)
  end
end

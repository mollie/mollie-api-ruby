class Application < Sinatra::Application
  swagger_path '/v2/methods' do
    operation :get, description: 'List methods https://www.mollie.com/en/docs/reference/methods/list', tags: ['Methods'] do
      parameter name: :include, in: 'query', description: 'Include additional data, e.g. issuers', type: :string
      parameter name: :recurring_type, in: 'query', description: 'Recurring type', type: :string, default: 'first'
      parameter name: :locale, in: 'query', description: 'Locale', type: :string
      parameter name: :profile_id, in: 'query', description: 'Profile ID', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/methods/{id}' do
    operation :get, description: 'Get method', tags: ['Methods'] do
      parameter name: :id, in: 'path', description: 'Method id', type: :string
      parameter name: :include, in: 'query', description: 'Include additional data, e.g. issuers', type: :string
      parameter name: :locale, in: 'query', description: 'Locale', type: :string
      parameter name: :profile_id, in: 'query', description: 'Profile ID', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v2/methods' do
    methods = Mollie::Method.all(include:        params[:include],
                                 recurring_type: params[:recurring_type],
                                 locale:         params[:locale],
                                 profile_id:     params[:profile_id],
                                 testmode:       params[:testmode]
    )
    JSON.pretty_generate(methods.attributes)
  end

  get '/v2/methods/:id' do
    method = Mollie::Method.get(params[:id],
                                include:    params[:include],
                                locale:     params[:locale],
                                profile_id: params[:profile_id],
                                testmode:   params[:testmode]
    )
    JSON.pretty_generate(method.attributes)
  end
end

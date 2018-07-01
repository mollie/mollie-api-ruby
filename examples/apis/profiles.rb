class Application < Sinatra::Application
  swagger_schema :ProfileRequest do
    property :name, type: :string, description: 'Name', example: "My website name"
    property :website, type: :string, description: 'Website', example: "#{Ngrok::Tunnel.ngrok_url_https}"
    property :email, type: :string, description: 'Email', example: "info@mywebsite.com"
    property :phone, type: :string, description: 'Phone', example: "31123456789"
    property :categoryCode, type: :integer, description: 'Category code', example: "5399"
    property :mode, type: :string, description: 'Mode (live or test)', example: "test"
  end

  swagger_path '/v2/profiles' do
    operation :post, description: 'https://www.mollie.com/en/docs/reference/profiles/create', tags: ['Profiles'] do
      security api_key: []
      parameter name: :profile, in: 'body', description: 'ProfileRequest params', schema: { '$ref' => '#/definitions/ProfileRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/profiles' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/profiles/list', tags: ['Profiles'] do
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/profiles/{id}' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/profiles/get', tags: ['Profiles'] do
      parameter name: :id, in: 'path', description: 'Profile id', type: :string, default: 'pfl_v9hTwCvYqw'
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
    operation :patch, description: 'https://www.mollie.com/en/docs/reference/profiles/create', tags: ['Profiles'] do
      parameter name: :id, in: 'path', description: 'Profile id', type: :string, default: 'pfl_v9hTwCvYqw'
      security api_key: []
      parameter name: :profile, in: 'body', description: 'ProfileRequest params', schema: { '$ref' => '#/definitions/ProfileRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
    operation :delete, description: 'https://www.mollie.com/en/docs/reference/profiles/delete', tags: ['Profiles'] do
      parameter name: :id, in: 'path', description: 'Profile id', type: :string, default: 'pfl_v9hTwCvYqw'
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v2/profiles' do
    profiles = Mollie::Profile.all
    JSON.pretty_generate(profiles.attributes)
  end

  get '/v2/profiles/:id' do
    profile = Mollie::Profile.get(params[:id])
    JSON.pretty_generate(profile.attributes)
  end

  post '/v2/profiles' do
    profile = Mollie::Profile.create(
      name:         json_params['name'],
      website:      json_params['website'],
      email:        json_params['email'],
      phone:        json_params['phone'],
      categoryCode: json_params['categoryCode'],
      mode:         json_params['mode'],
    )
    JSON.pretty_generate(profile.attributes)
  end

  patch '/v2/profiles/:id' do
    profile = Mollie::Profile.update(params[:id],
                                     name:         json_params['name'],
                                     website:      json_params['website'],
                                     email:        json_params['email'],
                                     phone:        json_params['phone'],
                                     categoryCode: json_params['categoryCode'],
                                     mode:         json_params['mode'],
    )
    JSON.pretty_generate(profile.attributes)
  end
end

class Application < Sinatra::Application
  swagger_schema :ProfileRequest do
    property :name, type: :string, description: 'Name', example: "My website name"
    property :website, type: :string, description: 'Website', example: "#{Ngrok::Tunnel.ngrok_url_https}"
    property :email, type: :string, description: 'Email', example: "info@mywebsite.com"
    property :phone, type: :string, description: 'Phone', example: "31123456789"
    property :categoryCode, type: :integer, description: 'Category code', example: "5399"
    property :mode, type: :string, description: 'Mode (live or test)', example: "test"
  end

  swagger_path '/v1/profiles' do
    operation :post, description: 'https://www.mollie.com/en/docs/reference/profiles/create', tags: ['Profiles'] do
      security api_key: []
      parameter name: :profile, in: 'body', description: 'ProfileRequest params', schema: { '$ref' => '#/definitions/ProfileRequest' }
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/profiles' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/profiles/list', tags: ['Profiles'] do
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/profiles/{id}' do
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

  swagger_path '/v1/profiles/{profile_id}/apikeys' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/profiles/api-keys/list', tags: ['Profiles'] do
      parameter name: :profile_id, in: 'path', description: 'Profile id', type: :string, default: 'pfl_v9hTwCvYqw'
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/profiles/{profile_id}/apikeys/{mode}' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/profiles/api-keys/list', tags: ['Profiles'] do
      parameter name: :profile_id, in: 'path', description: 'Profile id', type: :string, default: 'pfl_v9hTwCvYqw'
      parameter name: :mode, in: 'path', description: 'Mode (live or test)', type: :string, default: 'test'
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
    operation :post, description: 'https://www.mollie.com/en/docs/reference/profiles/api-keys/reset', tags: ['Profiles'] do
      parameter name: :profile_id, in: 'path', description: 'Profile id', type: :string, default: 'pfl_v9hTwCvYqw'
      parameter name: :mode, in: 'path', description: 'Mode (live or test)', type: :string, default: 'test'
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/profiles' do
    profiles = client.profiles.all(params[:offset], params[:count])
    JSON.pretty_generate(profiles.attributes)
  end

  get '/v1/profiles/:id' do
    profile = client.profiles.get(params[:id])
    JSON.pretty_generate(profile.attributes)
  end

  post '/v1/profiles' do
    profile = client.profiles.create(
      name:         json_params['name'],
      website:      json_params['website'],
      email:        json_params['email'],
      phone:        json_params['phone'],
      categoryCode: json_params['categoryCode'],
      mode:         json_params['mode'],
    )
    JSON.pretty_generate(profile.attributes)
  end

  patch '/v1/profiles/:id' do
    profile = client.profiles.update(params[:id],
                                     name:         json_params['name'],
                                     website:      json_params['website'],
                                     email:        json_params['email'],
                                     phone:        json_params['phone'],
                                     categoryCode: json_params['categoryCode'],
                                     mode:         json_params['mode'],
    )
    JSON.pretty_generate(profile.attributes)
  end

  get '/v1/profiles/:profile_id/apikeys' do
    api_keys = client.profiles_api_keys.with(params[:profile_id]).all
    JSON.pretty_generate(api_keys.attributes)
  end

  get '/v1/profiles/:profile_id/apikeys/:mode' do
    api_key = client.profiles_api_keys.with(params[:profile_id]).get(params[:mode])
    JSON.pretty_generate(api_key.attributes)
  end

  post '/v1/profiles/:profile_id/apikeys/:mode' do
    payment = client.profiles_api_keys.with(params[:profile_id]).create(params[:mode])
    JSON.pretty_generate(payment.attributes)
  end
end

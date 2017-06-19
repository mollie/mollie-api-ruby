require 'rack/oauth2'
class Application < Sinatra::Application
  swagger_path '/oauth2/authorize' do
    operation :get, description: 'https://www.mollie.com/en/docs/reference/oauth/authorize', tags: ['Connect'] do
      parameter name: :client_id, in: 'query', description: 'Client Id', type: :string
      parameter name: :secret, in: 'query', description: 'oAuth Secret', type: :string
      parameter name: :redirect_uri, in: 'query', description: 'Redirect URI', type: :string, default: "#{Ngrok::Tunnel.ngrok_url_https}/token"
      parameter name: :state, in: 'query', description: 'State', type: :string, default: SecureRandom.uuid
      parameter name: :scope, in: 'query', description: 'Scope', type: :string
      parameter name: :response_type, in: 'query', description: 'Response Type', type: :string
      parameter name: :approval_prompt, in: 'query', description: 'Approval prompt', type: :boolean
      security api_key: []
      response 301, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/issuers/{id}' do
    operation :get, description: 'Get issuer', tags: ['Issuers'] do
      parameter name: :id, in: 'path', description: 'Issuer id', type: :string
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/oauth2/authorize' do
    client = Rack::OAuth2::Client.new(
        identifier:             params[:client_id],
        secret:                 params[:secret],
        state:                  params[:state],
        redirect_uri:           params[:redirect_uri],
        authorization_endpoint: 'https://www.mollie.com/oauth2/authorize',
        token_endpoint:         'https://api.mollie.nl/oauth2/tokens'
    )
    client.authorization_uri(state: params[:state], scope: params[:scope], approval_prompt: params[:approval_prompt])
  end

  get '/token' do
    client = Rack::OAuth2::Client.new(
        identifier:             params[:client_id],
        secret:                 params[:secret],
        state:                  params[:state],
        redirect_uri:           "#{Ngrok::Tunnel.ngrok_url_https}/token",
        authorization_endpoint: 'https://www.mollie.com/oauth2/authorize',
        token_endpoint:         'https://api.mollie.nl/oauth2/tokens'
    )

    client.authorization_code = params['code']
    client.access_token!.access_token
  end
end

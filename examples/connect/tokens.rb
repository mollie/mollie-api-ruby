require 'rack/oauth2'

client = Rack::OAuth2::Client.new(
  identifier:             client_id,
  secret:                 secret,
  state:                  'some_state',
  redirect_uri:           redirect_url,
  authorization_endpoint: 'https://my.mollie.com/oauth2/authorize',
  token_endpoint:         'https://api.mollie.com/oauth2/tokens'
)

# Use the code returned as parameter on the redirect endpoint
client.authorization_code = params['code']
client.access_token!.access_token

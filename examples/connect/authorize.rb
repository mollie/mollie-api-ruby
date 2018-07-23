require 'rack/oauth2'

client = Rack::OAuth2::Client.new(
  identifier:             client_id,
  secret:                 secret,
  state:                  'some_state',
  redirect_uri:           redirect_url,
  authorization_endpoint: 'https://www.mollie.com/oauth2/authorize',
  token_endpoint:         'https://api.mollie.com/oauth2/tokens'
)

redirect_to client.authorization_uri(
  state:           'some_state',
  scope:           'payments.read refunds.write',
  approval_prompt: 'auto'
)

require 'sinatra'
require 'rack/oauth2'
require 'securerandom'
require 'net/https'

# Make sure the redirect uri is specified in the Mollie App settings
# https://www.mollie.com/dashboard/settings/applications
# oAuth2 requires https, so use the ngrok https endpoint
# Run with OAUTH_CLIENT_ID=<client_id> OAUTH_SECRET=<secret> NGROK=<https_ngrok> ruby examples/8-connect-api
# Visit https://xxxxxxx.ngrok.io/authorize

client = Rack::OAuth2::Client.new(
    identifier:             ENV['OAUTH_CLIENT_ID'],
    secret:                 ENV['OAUTH_SECRET'],
    redirect_uri:           "#{ENV['NGROK']}/token",
    authorization_endpoint: 'https://www.mollie.com/oauth2/authorize',
    token_endpoint:         'https://api.mollie.nl/oauth2/tokens'
)

get '/authorize' do
  redirect client.authorization_uri(state: SecureRandom.uuid)
end

get '/token' do
  client.authorization_code = params['code']
  client.access_token!.access_token
end

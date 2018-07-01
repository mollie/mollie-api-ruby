class Application < Sinatra::Application
  swagger_path '/v2/chargebacks' do
    operation :get, description: 'List chargebacks https://www.mollie.com/en/docs/reference/chargebacks/list', tags: ['Chargebacks'] do
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v2/chargebacks' do
    chargebacks = Mollie::Chargeback.all(testmode: params[:test_mode])
    JSON.pretty_generate(chargebacks.attributes)
  end
end

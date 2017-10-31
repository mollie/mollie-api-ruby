class Application < Sinatra::Application
  swagger_path '/v1/chargebacks' do
    operation :get, description: 'List chargebacks https://www.mollie.com/en/docs/reference/chargebacks/list', tags: ['Refunds'] do
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/chargebacks' do
    chargebacks = Mollie::Chargeback.all(params[:offset], params[:limit], testmode: params[:test_mode])
    JSON.pretty_generate(chargebacks.attributes)
  end
end

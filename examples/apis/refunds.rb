class Application < Sinatra::Application
  swagger_path '/v2/refunds' do
    operation :get, description: 'List refunds https://www.mollie.com/en/docs/reference/refunds/list', tags: ['Refunds'] do
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v2/refunds' do
    refunds = Mollie::Refund.all(params[:limit], testmode: params[:test_mode])
    JSON.pretty_generate(refunds.attributes)
  end
end

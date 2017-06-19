class Application < Sinatra::Application
  swagger_path '/v1/refunds' do
    operation :get, description: 'List refunds https://www.mollie.com/en/docs/reference/refunds/list', tags: ['Refunds'] do
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/refunds' do
    refunds = client.refunds.with(params[:customer_id]).all(params[:offset], params[:limit],
                                                            testmode: params[:test_mode])
    JSON.pretty_generate(refunds.attributes)
  end
end

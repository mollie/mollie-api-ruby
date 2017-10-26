class Application < Sinatra::Application
  swagger_path '/v1/settlements' do
    operation :get, description: 'List settlements https://www.mollie.com/en/docs/reference/settlements/list', tags: ['Settlements'] do
      parameter name: :reference, in: 'query', description: 'Issuer id', type: :string, example: "1182161.1506.02"
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/settlements/{id}' do
    operation :get, description: 'Get settlement https://www.mollie.com/en/docs/reference/settlements/get', tags: ['Settlements'] do
      parameter name: :id, in: 'path', description: 'Issuer id', type: :string, example: "stl_jDk30akdN"
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/settlements/next' do
    operation :get, description: 'Next settlement https://www.mollie.com/en/docs/reference/settlements/next', tags: ['Settlements'] do
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/settlements/open' do
    operation :get, description: 'Open settlement https://www.mollie.com/en/docs/reference/settlements/open', tags: ['Settlements'] do
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v1/settlements/{settlement_id}/payments' do
    operation :get, description: 'List settlement payments https://www.mollie.com/nl/docs/reference/settlements/list-payments', tags: ['Settlements'] do
      parameter name: :settlement_id, in: 'path', description: 'Settlement id', type: :string, example: "stl_jDk30akdN"
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      parameter name: :testmode, in: 'query', description: 'Test mode', type: :boolean
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v1/settlements' do
    settlements = Mollie::Settlement.all(params[:offset], params[:count],
                                         reference: params[:reference],
                                         testmode:  params[:testmode]
    )
    JSON.pretty_generate(settlements.attributes)
  end

  get '/v1/settlements/:id' do
    settlement = Mollie::Settlement.get(params[:id], testmode: params[:testmode])
    JSON.pretty_generate(settlement.attributes)
  end

  get '/v1/settlements/next' do
    settlement = Mollie::Settlement.next(testmode: params[:testmode])
    JSON.pretty_generate(settlement.attributes)
  end

  get '/v1/settlements/open' do
    settlement = Mollie::Settlement.open(testmode: params[:testmode])
    JSON.pretty_generate(settlement.attributes)
  end


  get '/v1/settlements/:settlement_id/payments' do
    payments = Mollie::Settlement::Payment.all(params[:offset], params[:count], testmode: params[:testmode], settlement_id: params[:settlement_id])
    JSON.pretty_generate(payments.attributes)
  end


end

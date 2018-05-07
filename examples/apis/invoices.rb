class Application < Sinatra::Application
  swagger_path '/v2/invoices' do
    operation :get, description: 'List invoices https://www.mollie.com/en/docs/reference/invoices/list', tags: ['Invoices'] do
      parameter name: :include, in: 'query', description: 'Include', type: :string, example: "lines,settlements"
      parameter name: :reference, in: 'query', description: 'Issuer id', type: :string, example: "inv_FrvewDA3Pr"
      parameter name: :year, in: 'query', description: 'Issuer id', type: :integer, example: Time.now.year
      parameter name: :offset, in: 'query', description: 'Offset', type: :integer
      parameter name: :count, in: 'query', description: 'Count', type: :integer
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  swagger_path '/v2/invoices/{id}' do
    operation :get, description: 'Get invoice', tags: ['Invoices'] do
      parameter name: :id, in: 'path', description: 'Issuer id', type: :string, example: "inv_FrvewDA3Pr"
      parameter name: :include, in: 'query', description: 'Includes', type: :string, example: "lines,settlements"
      security api_key: []
      response 200, description: 'Successful response'
      response 500, description: 'Unexpected error'
    end
  end

  get '/v2/invoices' do
    invoices = Mollie::Invoice.all(params[:offset], params[:count],
                                   include:   params[:include],
                                   reference: params[:reference],
                                   year:      params[:year]
    )
    JSON.pretty_generate(invoices.attributes)
  end

  get '/v2/invoices/:id' do
    invoice = Mollie::Invoice.get(params[:id], include: params[:include])
    JSON.pretty_generate(invoice.attributes)
  end
end

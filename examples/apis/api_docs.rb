class Application < Sinatra::Application
  ::Application
  swagger_root do
    key :swagger, '2.0'
    info version:        Mollie::API::Client::VERSION,
         title:          'Mollie',
         description:    'Examples for the mollie api',
         termsOfService: 'https://github.com/mollie/mollie-api-ruby',
         contact:        { name: 'Mollie B.V.' },
         license:        { name: 'BSD' }
    key :basePath, '/'
    key :consumes, %w(application/json multipart/form-data)
    key :produces, ['application/json', "text/plain"]

    security_definition :api_key do
      key :type, :apiKey
      key :name, :"X-Mollie-Api-Key"
      key :in, :header
    end
  end

  swagger_schema :ErrorModel do
    property :message do
      key :type, :string
    end
  end

  get '/' do
    # redirect "http://petstore.swagger.io/?url=#{Ngrok::Tunnel.ngrok_url_https}/api-docs"
    redirect "#{Ngrok::Tunnel.ngrok_url_https}/index.html"
  end

  get '/api-docs' do
    content_type :json
    Swagger::Blocks.build_root_json([Application ]).to_json
  end
end

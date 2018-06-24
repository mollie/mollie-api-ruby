module Mollie
  class Client
    API_ENDPOINT = 'https://api.mollie.nl'
    API_VERSION  = 'v2'

    MODE_TEST = 'test'
    MODE_LIVE = 'live'

    class << self
      attr_accessor :configuration
    end

    class Configuration
      attr_accessor :api_key

      def initialize
        @api_key = ''
      end
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    # @return [Mollie::Client]
    def self.instance
      Thread.current['MOLLIE_CLIENT'] ||= begin
        self.configuration ||= Configuration.new
        new(configuration.api_key)
      end
    end

    def self.with_api_key(api_key)
      Thread.current['MOLLIE_API_KEY'] = instance.api_key
      instance.api_key                 = api_key
      yield
    ensure
      instance.api_key                 = Thread.current['MOLLIE_API_KEY']
      Thread.current['MOLLIE_API_KEY'] = nil
    end

    attr_accessor :api_key,
                  :api_endpoint

    def initialize(api_key = nil)
      @api_endpoint    = API_ENDPOINT
      @api_key         = api_key
      @version_strings = []

      add_version_string 'Mollie/' << VERSION
      add_version_string 'Ruby/' << RUBY_VERSION
      add_version_string OpenSSL::OPENSSL_VERSION.split(' ').slice(0, 2).join '/'
    end

    def api_endpoint=(api_endpoint)
      @api_endpoint = api_endpoint.chomp('/')
    end

    def add_version_string(version_string)
      @version_strings << version_string.gsub(/\s+/, '-')
    end

    def perform_http_call(http_method, api_method, id = nil, http_body = {}, query = {})
      path         = "/#{API_VERSION}/#{api_method}/#{id}".chomp('/')
      api_key      = http_body.delete(:api_key) || query.delete(:api_key) || @api_key
      api_endpoint = http_body.delete(:api_endpoint) || query.delete(:api_endpoint) || @api_endpoint

      if query.length > 0
        camelized_query = Util.camelize_keys(query)
        path            += "?#{URI.encode_www_form(camelized_query)}"
      end

      uri                = URI.parse(api_endpoint)
      client             = Net::HTTP.new(uri.host, uri.port)
      client.use_ssl     = true
      client.verify_mode = OpenSSL::SSL::VERIFY_PEER
      client.ca_file     = (File.expand_path '../cacert.pem', File.dirname(__FILE__))

      case http_method
      when 'GET'
        request = Net::HTTP::Get.new(path)
      when 'POST'
        http_body.delete_if { |k, v| v.nil? }
        request      = Net::HTTP::Post.new(path)
        request.body = Util.camelize_keys(http_body).to_json
      when 'DELETE'
        http_body.delete_if { |k, v| v.nil? }
        request      = Net::HTTP::Delete.new(path)
        request.body = Util.camelize_keys(http_body).to_json
      else
        raise Mollie::Exception.new("Invalid HTTP Method: #{http_method}")
      end

      request['Accept']        = 'application/json'
      request['Content-Type']  = 'application/json'
      request['Authorization'] = "Bearer #{api_key}"
      request['User-Agent']    = @version_strings.join(' ')

      begin
        response = client.request(request)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        raise Mollie::Exception.new(e.message)
      end

      http_code = response.code.to_i
      case http_code
      when 200, 201
        Util.nested_underscore_keys(JSON.parse(response.body))
      when 204
        {} # No Content
      else
        json = JSON.parse(response.body)
        exception = Mollie::Exception.new(json)
        raise exception
      end
    end
  end
end

module Mollie
  class Client
    API_ENDPOINT = 'https://api.mollie.com'.freeze
    API_VERSION  = 'v2'.freeze

    MODE_TEST = 'test'.freeze
    MODE_LIVE = 'live'.freeze

    class << self
      attr_accessor :configuration
    end

    class Configuration
      attr_accessor :api_key, :open_timeout, :read_timeout

      def initialize
        @api_key = ''
        @open_timeout = 60
        @read_timeout = 60
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
      path = if api_method.start_with?(API_ENDPOINT)
        URI.parse(api_method).path
      else
        "/#{API_VERSION}/#{api_method}/#{id}".chomp('/')
      end

      api_key      = http_body.delete(:api_key) || query.delete(:api_key) || @api_key
      api_endpoint = http_body.delete(:api_endpoint) || query.delete(:api_endpoint) || @api_endpoint
      idempotency_key = http_body.delete(:idempotency_key) || query.delete(:idempotency_key)

      unless query.empty?
        camelized_query = Util.camelize_keys(query)
        path += "?#{build_nested_query(camelized_query)}"
      end

      uri                 = URI.parse(api_endpoint)
      client              = Net::HTTP.new(uri.host, uri.port)
      client.use_ssl      = true
      client.verify_mode  = OpenSSL::SSL::VERIFY_PEER
      client.ca_file      = (File.expand_path '../cacert.pem', File.dirname(__FILE__))
      client.read_timeout = self.class.configuration.read_timeout
      client.open_timeout = self.class.configuration.open_timeout

      case http_method
      when 'GET'
        request = Net::HTTP::Get.new(path)
      when 'POST'
        http_body.delete_if { |_k, v| v.nil? }
        request      = Net::HTTP::Post.new(path)
        request.body = Util.camelize_keys(http_body).to_json
      when 'PATCH'
        http_body.delete_if { |_k, v| v.nil? }
        request      = Net::HTTP::Patch.new(path)
        request.body = Util.camelize_keys(http_body).to_json
      when 'DELETE'
        http_body.delete_if { |_k, v| v.nil? }
        request      = Net::HTTP::Delete.new(path)
        request.body = Util.camelize_keys(http_body).to_json
      else
        raise Mollie::Exception, "Invalid HTTP Method: #{http_method}"
      end

      request['Accept']        = 'application/json'
      request['Content-Type']  = 'application/json'
      request['Authorization'] = "Bearer #{api_key}"
      request['User-Agent']    = @version_strings.join(' ')

      if http_method == 'POST' && idempotency_key
        request['Idempotency-Key'] = idempotency_key
      end

      begin
        response = client.request(request)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        raise Mollie::Exception, e.message
      end

      http_code = response.code.to_i
      case http_code
      when 200, 201
        Util.nested_underscore_keys(JSON.parse(response.body))
      when 204
        {} # No Content
      when 404
        json = JSON.parse(response.body)
        exception = ResourceNotFoundError.new(json)
        raise exception
      else
        json = JSON.parse(response.body)
        exception = Mollie::RequestError.new(json)
        raise exception
      end
    end

    private

    def build_nested_query(value, prefix = nil)
      case value
      when Array
        value.map do |v|
          build_nested_query(v, "#{prefix}[]")
        end.join('&')
      when Hash
        value.map do |k, v|
          build_nested_query(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k))
        end.reject(&:empty?).join('&')
      when nil
        prefix
      else
        raise ArgumentError, 'value must be a Hash' if prefix.nil?
        "#{prefix}=#{escape(value)}"
      end
    end

    def escape(s)
      URI.encode_www_form_component(s)
    end
  end
end

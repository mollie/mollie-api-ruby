require "json"
require "time"
require "ostruct"
require "bigdecimal"

["exception",
 "util",
 "client/version",
 "resource/base",
 "resource/customers",
 "resource/customers/payments",
 "resource/customers/mandates",
 "resource/customers/subscriptions",
 "resource/payments",
 "resource/payments/refunds",
 "resource/issuers",
 "resource/methods",
 "object/base",
 "object/list",
 "object/customer",
 "object/mandate",
 "object/subscription",
 "object/payment",
 "object/payment/refund",
 "object/issuer",
 "object/method"].each { |file| require File.expand_path file, File.dirname(__FILE__) }

module Mollie
  module API
    class Client
      API_ENDPOINT = "https://api.mollie.nl"
      API_VERSION  = "v1"

      attr_accessor :api_key
      attr_reader :payments, :issuers, :methods, :payments_refunds,
                  :customers, :customers_payments, :customers_mandates, :customers_subscriptions,
                  :api_endpoint

      def initialize(api_key, options = {})
        @payments                = Mollie::API::Resource::Payments.new self
        @issuers                 = Mollie::API::Resource::Issuers.new self
        @methods                 = Mollie::API::Resource::Methods.new self
        @payments_refunds        = Mollie::API::Resource::Payments::Refunds.new self
        @customers               = Mollie::API::Resource::Customers.new self
        @customers_payments      = Mollie::API::Resource::Customers::Payments.new self
        @customers_mandates      = Mollie::API::Resource::Customers::Mandates.new self
        @customers_subscriptions = Mollie::API::Resource::Customers::Subscriptions.new self

        @api_endpoint    = API_ENDPOINT
        @api_key         = api_key
        @options         = options
        @version_strings = []

        add_version_string "Mollie/" << VERSION
        add_version_string "Ruby/" << RUBY_VERSION
        add_version_string OpenSSL::OPENSSL_VERSION.split(" ").slice(0, 2).join "/"
      end

      def api_endpoint=(api_endpoint)
        @api_endpoint = api_endpoint.chomp "/"
      end

      def add_version_string(version_string)
        @version_strings << (version_string.gsub /\s+/, "-")
      end

      def perform_http_call(http_method, api_method, id = nil, http_body = {}, query = {})
        path = "/#{API_VERSION}/#{api_method}/#{id}".chomp('/')
        path += "?#{URI.encode_www_form(query)}" if query.length > 0

        case http_method
          when 'GET'
            request = Net::HTTP::Get.new(path)
          when 'POST'
            http_body.delete_if { |k, v| v.nil? }
            request      = Net::HTTP::Post.new(path)
            request.body = Util.camelize_keys(http_body).to_json
          when 'DELETE'
            request = Net::HTTP::Delete.new(path)
          else
            raise Mollie::API::Exception.new("Invalid HTTP Method: #{http_method}")
        end

        request['Accept']        = 'application/json'
        request['Authorization'] = "Bearer #{@api_key}"
        request['User-Agent']    = @options[:user_agent] ? @options[:user_agent] : @version_strings.join(" ")

        begin
          response = client.request(request)
        rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
            Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
          raise Mollie::API::Exception.new(e.message)
        end

        http_code = response.code.to_i
        case http_code
          when 200, 201
            Util.nested_underscore_keys(JSON.parse(response.body))
          when 204
            {} # No Content
          else
            response        = JSON.parse(response.body)
            exception       = Mollie::API::Exception.new response['error']['message']
            exception.code  = http_code
            exception.field = response['error']['field'] unless response['error']['field'].nil?
            raise exception
        end
      end

      private

      def client
        return @client if defined? @client
        uri                 = URI.parse(@api_endpoint)
        @client             = Net::HTTP.new(uri.host, uri.port)
        @client.use_ssl     = true
        @client.verify_mode = OpenSSL::SSL::VERIFY_PEER
        @client.ca_file     = (File.expand_path "cacert.pem", File.dirname(__FILE__))
        @client
      end
    end
  end
end

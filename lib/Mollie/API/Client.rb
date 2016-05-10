require "json"
require "rest_client"

["Exception",
"Client/Version",
"Resource/Base",
"Resource/Customers",
"Resource/Customers/Payments",
"Resource/Customers/Mandates",
"Resource/Payments",
"Resource/Payments/Refunds",
"Resource/Issuers",
"Resource/Methods",
"Object/Base",
"Object/List",
"Object/Customer",
"Object/Mandate",
"Object/Payment",
"Object/Payment/Refund",
"Object/Issuer",
"Object/Method"].each {|file| require File.expand_path file, File.dirname(__FILE__) }

module Mollie
  module API
    class Client
      API_ENDPOINT   = "https://api.mollie.nl"
      API_VERSION    = "v1"

      attr_reader :payments, :issuers, :methods, :payments_refunds, :customers, :customers_payments, :customers_mandates

      def initialize
        @payments           = Mollie::API::Resource::Payments.new self
        @issuers            = Mollie::API::Resource::Issuers.new self
        @methods            = Mollie::API::Resource::Methods.new self
        @payments_refunds   = Mollie::API::Resource::Payments::Refunds.new self
        @customers          = Mollie::API::Resource::Customers.new self
        @customers_payments = Mollie::API::Resource::Customers::Payments.new self
        @customers_mandates = Mollie::API::Resource::Customers::Mandates.new self

        @api_endpoint    = API_ENDPOINT
        @api_key         = ""
        @version_strings = []

        addVersionString "Mollie/" << CLIENT_VERSION
        addVersionString "Ruby/" << RUBY_VERSION
        addVersionString OpenSSL::OPENSSL_VERSION.split(" ").slice(0, 2).join "/"
      end

      def setApiEndpoint(api_endpoint)
        @api_endpoint = api_endpoint.chomp "/"
      end

      alias_method :api_endpoint=, :setApiEndpoint

      def getApiEndpoint
        @api_endpoint
      end

      alias_method :api_endpoint, :getApiEndpoint

      def setApiKey(api_key)
        @api_key = api_key
      end

      alias_method :api_key=, :setApiKey

      def addVersionString(version_string)
        @version_strings << (version_string.gsub /\s+/, "-")
      end

      def _getRestClient(request_url, request_headers)
        RestClient::Resource.new request_url,
          :headers     => request_headers,
          :ssl_ca_file => (File.expand_path "cacert.pem", File.dirname(__FILE__)),
          :verify_ssl  => OpenSSL::SSL::VERIFY_PEER
      end

      def performHttpCall(http_method, api_method, id = nil, http_body = nil)
        request_headers = {
          :accept => :json,
          :authorization => "Bearer #{@api_key}",
          :user_agent => @version_strings.join(" "),
          "X-Mollie-Client-Info" => getUname
        }

        if http_body.respond_to? :delete_if
          http_body.delete_if { |k, v| v.nil? }
        end

        http_code = nil
        begin
          request_url = "#{@api_endpoint}/#{API_VERSION}/#{api_method}/#{id}".chomp "/"
          rest_client = _getRestClient request_url, request_headers

          case http_method
          when "GET"
            response = rest_client.get
          when "POST"
            response = rest_client.post http_body
          when "DELETE"
            response = rest_client.delete
          end
          response = JSON.parse response, :symbolize_names => true
        rescue RestClient::ExceptionWithResponse => e
          http_code = e.http_code
          response = JSON.parse e.response, :symbolize_names => true
          raise e if response[:error].nil?
        end

        unless response[:error].nil?
          exception = Mollie::API::Exception.new response[:error][:message]
          exception.code = http_code
          exception.field = response[:error][:field] unless response[:error][:field].nil?
          raise exception
        end

        response
      end

      def getUname
        `uname -a 2>/dev/null`.strip if RUBY_PLATFORM =~ /linux|darwin/i
      rescue Errno::ENOMEM
        "uname lookup failed"
      end
    end
  end
end

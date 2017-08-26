require 'helper'

module Mollie
  class ClientTest < Test::Unit::TestCase
    def client
      Mollie::Client.new("test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM")
    end

    def test_initialize
      assert_equal "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM", client.api_key
    end

    def test_setting_the_api_endpoint
      client              = self.client
      client.api_endpoint = "http://my.endpoint/"
      assert_equal "http://my.endpoint", client.api_endpoint
    end

    def test_perform_http_call_defaults
      stub_request(:any, "https://api.mollie.nl/v1/my-method")
        .with(:headers => { 'Accept'        => 'application/json',
                            'Content-type'  => 'application/json',
                            'Authorization' => 'Bearer test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM',
                            'User-Agent'    => /^Mollie\/#{Mollie::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/ })
        .to_return(:status => 200, :body => "{}", :headers => {})
      client.perform_http_call("GET", "my-method", nil, {})
    end

    def test_get_request_convert_to_camel_case
      stub_request(:get, "https://api.mollie.nl/v1/my-method?myParam=ok")
        .to_return(:status => 200, :body => "{}", :headers => {})
      client.perform_http_call("GET", "my-method", nil, {}, { my_param: "ok" })
    end

    def test_get_response_convert_to_snake_case
      response_body = <<-JSON
          {
            "someCamelCased" : {
              "alsoNested": "camelCaseValue"
            },
            "evenLists": [
              {
                "withCamelCase": "camelCaseValue"
              }
            ]
          }
      JSON

      expected_response = {
        'some_camel_cased' =>
          { 'also_nested' => "camelCaseValue" },
        'even_lists'       => [
          { 'with_camel_case' => "camelCaseValue" }
        ]
      }

      stub_request(:get, "https://api.mollie.nl/v1/my-method")
        .to_return(:status => 200, :body => response_body, :headers => {})
      response = client.perform_http_call("GET", "my-method", nil, {})

      assert_equal expected_response, response
    end

    def test_post_requests_convert_to_camel_case
      expected_body = %{{"redirectUrl":"my-url"}}

      stub_request(:post, "https://api.mollie.nl/v1/my-method")
        .with(body: expected_body)
        .to_return(:status => 200, :body => "{}", :headers => {})

      client.perform_http_call("POST", "my-method", nil, redirect_url: "my-url")
    end

    def test_delete_requests_with_no_content_responses
      stub_request(:delete, "https://api.mollie.nl/v1/my-method/1")
        .to_return(:status => 204, :body => "", :headers => {})

      client.perform_http_call("DELETE", "my-method", "1")
    end

    def test_error_response
      response = <<-JSON
          {"error": {"message": "Error on field", "field": "my-field"}}
      JSON
      stub_request(:post, "https://api.mollie.nl/v1/my-method")
        .to_return(:status => 500, :body => response, :headers => {})

      e = assert_raise Mollie::API::Exception.new("Error on field") do
        client.perform_http_call("POST", "my-method", nil, {})
      end

      assert_equal "my-field", e.field
    end
  end
end

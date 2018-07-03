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
      stub_request(:any, "https://api.mollie.com/v2/my-method")
        .with(:headers => { 'Accept'        => 'application/json',
                            'Content-type'  => 'application/json',
                            'Authorization' => 'Bearer test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM',
                            'User-Agent'    => /^Mollie\/#{Mollie::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/ })
        .to_return(:status => 200, :body => "{}", :headers => {})
      client.perform_http_call("GET", "my-method", nil, {})
    end

    def test_perform_http_call_key_override
      stub_request(:any, "https://localhost/v2/my-method")
        .with(:headers => { 'Accept'        => 'application/json',
                            'Content-type'  => 'application/json',
                            'Authorization' => 'Bearer my_key',
                            'User-Agent'    => /^Mollie\/#{Mollie::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/ })
        .to_return(:status => 200, :body => "{}", :headers => {})
      client.perform_http_call("GET", "my-method", nil, {api_key: 'my_key', api_endpoint: 'https://localhost'})
      client.perform_http_call("GET", "my-method", nil, {}, {api_key: 'my_key', api_endpoint: 'https://localhost'})
    end

    def test_perform_http_call_with_api_key_block
      stub_request(:any, "https://api.mollie.com/v2/my-method")
        .with(:headers => { 'Accept'        => 'application/json',
                            'Content-type'  => 'application/json',
                            'Authorization' => 'Bearer my_key',
                            'User-Agent'    => /^Mollie\/#{Mollie::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/ })
        .to_return(:status => 200, :body => "{}", :headers => {})

      Mollie::Client.instance.api_key = "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM"
      Mollie::Client.with_api_key("my_key") do
        assert_equal "my_key", Mollie::Client.instance.api_key
        Mollie::Client.instance.perform_http_call("GET", "my-method", nil, {})
      end
      assert_equal "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM", Mollie::Client.instance.api_key
    end

    def test_get_request_convert_to_camel_case
      stub_request(:get, "https://api.mollie.com/v2/my-method?myParam=ok")
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

      stub_request(:get, "https://api.mollie.com/v2/my-method")
        .to_return(:status => 200, :body => response_body, :headers => {})
      response = client.perform_http_call("GET", "my-method", nil, {})

      assert_equal expected_response, response
    end

    def test_post_requests_convert_to_camel_case
      expected_body = %{{"redirectUrl":"my-url"}}

      stub_request(:post, "https://api.mollie.com/v2/my-method")
        .with(body: expected_body)
        .to_return(:status => 200, :body => "{}", :headers => {})

      client.perform_http_call("POST", "my-method", nil, redirect_url: "my-url")
    end

    def test_delete_requests_with_no_content_responses
      stub_request(:delete, "https://api.mollie.com/v2/my-method/1")
        .to_return(:status => 204, :body => "", :headers => {})

      client.perform_http_call("DELETE", "my-method", "1")
    end

    def test_error_response
      response = <<-JSON
        {
            "status": 401,
            "title": "Unauthorized Request",
            "detail": "Missing authentication, or failed to authenticate",
            "field": "test-field",
            "_links": {
                "documentation": {
                    "href": "https://www.mollie.com/en/docs/authentication",
                    "type": "text/html"
                }
            }
        }
      JSON

      json = JSON.parse(response)
      stub_request(:post, "https://api.mollie.com/v2/my-method")
        .to_return(:status => 401, :body => response, :headers => {})

      e = assert_raise Mollie::Exception.new(JSON.parse(response)) do
        client.perform_http_call("POST", "my-method", nil, {})
      end

      assert_equal(json['status'], e.status)
      assert_equal(json['title'],  e.title)
      assert_equal(json['detail'], e.detail)
      assert_equal(json['field'],  e.field)
      assert_equal(json['_links'], e.links)
    end
  end
end

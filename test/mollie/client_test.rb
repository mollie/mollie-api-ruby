require 'helper'

module Mollie
  class ClientTest < Test::Unit::TestCase
    def client
      Mollie::Client.new('test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM')
    end

    def test_initialize
      assert_equal 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM', client.api_key
    end

    def test_setting_the_api_endpoint
      client              = self.client
      client.api_endpoint = 'http://my.endpoint/'
      assert_equal 'http://my.endpoint', client.api_endpoint
    end

    def test_perform_http_call_defaults
      stub_request(:any, 'https://api.mollie.com/v2/my-method')
        .with(headers: { 'Accept' => 'application/json',
                         'Content-type'  => 'application/json',
                         'Authorization' => 'Bearer test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM',
                         'User-Agent'    => /^Mollie\/#{Mollie::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/ })
        .to_return(status: 200, body: '{}', headers: {})
      client.perform_http_call('GET', 'my-method', nil, {})
    end

    def test_perform_http_call_key_override
      stub_request(:any, 'https://localhost/v2/my-method')
        .with(headers: { 'Accept' => 'application/json',
                         'Content-type'  => 'application/json',
                         'Authorization' => 'Bearer my_key',
                         'User-Agent'    => /^Mollie\/#{Mollie::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/ })
        .to_return(status: 200, body: '{}', headers: {})
      client.perform_http_call('GET', 'my-method', nil, { api_key: 'my_key', api_endpoint: 'https://localhost' })
      client.perform_http_call('GET', 'my-method', nil, {}, { api_key: 'my_key', api_endpoint: 'https://localhost' })
    end

    def test_perform_http_call_with_api_key_block
      stub_request(:any, 'https://api.mollie.com/v2/my-method')
        .with(headers: { 'Accept' => 'application/json',
                         'Content-type'  => 'application/json',
                         'Authorization' => 'Bearer my_key',
                         'User-Agent'    => /^Mollie\/#{Mollie::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/ })
        .to_return(status: 200, body: '{}', headers: {})

      Mollie::Client.instance.api_key = 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
      Mollie::Client.with_api_key('my_key') do
        assert_equal 'my_key', Mollie::Client.instance.api_key
        Mollie::Client.instance.perform_http_call('GET', 'my-method', nil, {})
      end
      assert_equal 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM', Mollie::Client.instance.api_key
    end

    def test_post_with_idempotency_key
      stub_request(:post, 'https://api.mollie.com/v2/payments')
        .with(headers: { "Idempotency-Key" => '91d42bd5-e47f-4f4a-b38e-99333b264e78' })
        .to_return(status: 200, body: '{}', headers: {})

      payment = Mollie::Payment.create(
        amount: { value: '10.00', currency: 'EUR' },
        redirect_url: 'https://webshop.example.org/order/12345/',
        idempotency_key: '91d42bd5-e47f-4f4a-b38e-99333b264e78'
      )
    end

    def test_get_request_convert_to_camel_case
      stub_request(:get, 'https://api.mollie.com/v2/my-method?myParam=ok')
        .to_return(status: 200, body: '{}', headers: {})
      client.perform_http_call('GET', 'my-method', nil, {}, { my_param: 'ok' })
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
          { 'also_nested' => 'camelCaseValue' },
        'even_lists'       => [
          { 'with_camel_case' => 'camelCaseValue' }
        ]
      }

      stub_request(:get, 'https://api.mollie.com/v2/my-method')
        .to_return(status: 200, body: response_body, headers: {})
      response = client.perform_http_call('GET', 'my-method', nil, {})

      assert_equal expected_response, response
    end

    def test_post_requests_convert_to_camel_case
      expected_body = %({"redirectUrl":"my-url"})

      stub_request(:post, 'https://api.mollie.com/v2/my-method')
        .with(body: expected_body)
        .to_return(status: 200, body: '{}', headers: {})

      client.perform_http_call('POST', 'my-method', nil, redirect_url: 'my-url')
    end

    def test_delete_requests_with_no_content_responses
      stub_request(:delete, 'https://api.mollie.com/v2/my-method/1')
        .to_return(status: 204, body: '', headers: {})

      client.perform_http_call('DELETE', 'my-method', '1')
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
      stub_request(:post, 'https://api.mollie.com/v2/my-method')
        .to_return(status: 401, body: response, headers: {})

      e = assert_raise Mollie::RequestError.new(JSON.parse(response)) do
        client.perform_http_call('POST', 'my-method', nil, {})
      end

      assert_equal(json['status'], e.status)
      assert_equal(json['title'],  e.title)
      assert_equal(json['detail'], e.detail)
      assert_equal(json['field'],  e.field)
      assert_equal(json['_links'], e.links)
    end

    def test_404_response
      response = <<-JSON
      {
        "status": 404,
        "title": "Not Found",
        "detail": "No payment exists with token tr_WDqYK6vllg.",
        "_links": {
          "documentation": {
            "href": "https://docs.mollie.com/guides/handling-errors",
            "type": "text/html"
          }
        }
      }
      JSON

      json = JSON.parse(response)
      stub_request(:post, 'https://api.mollie.com/v2/my-method')
        .to_return(status: 404, body: response, headers: {})

      e = assert_raise ResourceNotFoundError.new(JSON.parse(response)) do
        client.perform_http_call('POST', 'my-method', nil, {})
      end

      assert_equal(json['status'], e.status)
      assert_equal(json['title'],  e.title)
      assert_equal(json['detail'], e.detail)
      assert_equal(json['field'],  e.field)
      assert_equal(json['_links'], e.links)
    end

    def test_invalid_response
      stub_request(:post, 'https://api.mollie.com/v2/my-method')
        .to_return(status: [500, "Internal server error"], body: "<h1>Internal server error</h1>", headers: {})

      e = assert_raise Mollie::RequestError do
        client.perform_http_call('POST', 'my-method', nil, {})
      end

      assert_equal(500, e.status)
      assert_equal('Internal server error', e.title)
      assert_match(/Unable to parse JSON:.*/, e.detail)
    end
  end
end

require 'helper'

module Mollie
  class ExceptionTest < Test::Unit::TestCase
    def test_attributes
      stub_request(:post, 'https://api.mollie.com/v2/payments')
        .to_return(status: 422, headers: { "Content-Type" => "application/hal+json}" }, body: %(
          {
              "status": 422,
              "title": "Unprocessable Entity",
              "detail": "The amount is higher than the maximum",
              "field": "amount",
              "_links": {
                 "documentation": {
                      "href": "https://docs.mollie.com/errors",
                      "type": "text/html"
                  }
              }
          }
        ))

      exception = assert_raise(Mollie::RequestError) do
        Mollie::Payment.create(
          amount:       { value: "1000000000.00", currency: "EUR" },
          description:  "Order #66",
          redirect_url: "https://www.example.org/payment/completed",
        )
      end

      assert_equal 422, exception.status
      assert_equal "Unprocessable Entity", exception.title
      assert_equal "The amount is higher than the maximum", exception.detail
      assert_equal "amount", exception.field
      assert_equal "https://docs.mollie.com/errors", exception.links["documentation"]["href"]
      assert_equal "text/html", exception.links["documentation"]["type"]
    end

    def test_exception_message
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 401, headers: { "Content-Type" => "application/hal+json}" }, body: %(
          {
              "status": 401,
              "title": "Unauthorized Request",
              "detail": "Missing authentication, or failed to authenticate",
              "_links": {
                  "documentation": {
                      "href": "https://docs.mollie.com/overview/authentication",
                      "type": "text/html"
                  }
              }
          }
        ))

      exception = assert_raise(Mollie::RequestError) { Payment.get('tr_WDqYK6vllg') }
      assert_equal '401 Unauthorized Request: Missing authentication, or failed to authenticate', exception.message
    end

    def test_http_attributes
      body = %({
        "status": 422,
        "title": "Unprocessable Entity",
        "detail": "The amount is higher than the maximum",
        "field": "amount",
        "_links": {
          "documentation": {
            "href": "https://docs.mollie.com/errors",
            "type": "text/html"
          }
        }
      })

      stub_request(:post, 'https://api.mollie.com/v2/payments')
        .to_return(status: 422, headers: { "Content-Type" => "application/hal+json" }, body: body)

      exception = assert_raise(Mollie::RequestError) do
        Mollie::Payment.create(
          amount:       { value: "1000000000.00", currency: "EUR" },
          description:  "Order #66",
          redirect_url: "https://www.example.org/payment/completed",
        )
      end

      assert_equal({ "content-type" => ["application/hal+json"] }, exception.http_headers)
      assert_equal(body, exception.http_body)
    end
  end
end

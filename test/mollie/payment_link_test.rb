require "helper"

module Mollie
  class PaymentLinkTest < Test::Unit::TestCase
    CREATE_PAYMENT_LINK = read_fixture("payment_links/create.json")
    GET_PAYMENT_LINK = read_fixture("payment_links/get.json")
    UPDATE_PAYMENT_LINK = read_fixture("payment_links/update.json")
    LIST_PAYMENT_LINKS = read_fixture("payment_links/list.json")
    LIST_PAYMENT_LINK_PAYMENTS = read_fixture("payment_links/list-payments.json")

    def test_archived?
      assert PaymentLink.new(archived: true).archived?
      assert_false PaymentLink.new(archived: false).archived?
    end

    def test_create_payment
      minified_body = JSON.parse(CREATE_PAYMENT_LINK).to_json
      stub_request(:post, "https://api.mollie.com/v2/payment-links")
        .with(body: minified_body)
        .to_return(status: 201, body: GET_PAYMENT_LINK, headers: {})

      payment_link = PaymentLink.create(
        description: "Bicycle tires",
        amount: {currency: "EUR", value: "24.95"}
      )

      assert_kind_of PaymentLink, payment_link
      assert_equal "pl_4Y0eZitmBnQ6IDoMqZQKh", payment_link.id
    end

    def test_get_payment_link
      stub_request(:get, "https://api.mollie.com/v2/payment-links/pl_4Y0eZitmBnQ6IDoMqZQKh")
        .to_return(status: 200, body: GET_PAYMENT_LINK, headers: {})

      payment_link = PaymentLink.get("pl_4Y0eZitmBnQ6IDoMqZQKh")

      assert_equal "pl_4Y0eZitmBnQ6IDoMqZQKh", payment_link.id
      assert_equal "test", payment_link.mode
      assert_equal "Bicycle tires", payment_link.description
      assert_false payment_link.archived
      assert_equal "pfl_QkEhN94Ba", payment_link.profile_id
      assert_equal 24.95, payment_link.amount.value
      assert_equal "EUR", payment_link.amount.currency
      assert_equal "https://webshop.example.org/payment-links/webhook", payment_link.webhook_url
      assert_equal "https://webshop.example.org/thanks", payment_link.redirect_url
      assert_equal Time.parse("2024-09-24T12:16:44+00:00"), payment_link.created_at
      assert_equal "https://paymentlink.mollie.com/payment/4Y0eZitmBnQ6IDoMqZQKh", payment_link.payment_link
      assert_nil payment_link.paid_at
      assert_nil payment_link.updated_at
      assert_nil payment_link.expires_at
    end

    def test_update_payment_link
      minified_body = JSON.parse(UPDATE_PAYMENT_LINK).to_json
      stub_request(:patch, 'https://api.mollie.com/v2/payment-links/pl_4Y0eZitmBnQ6IDoMqZQKh')
        .with(body: minified_body)
        .to_return(status: 200, body: GET_PAYMENT_LINK, headers: {})

      payment_link = PaymentLink.update("pl_4Y0eZitmBnQ6IDoMqZQKh", JSON.parse(UPDATE_PAYMENT_LINK))

      assert_kind_of PaymentLink, payment_link
      assert_equal "pl_4Y0eZitmBnQ6IDoMqZQKh", payment_link.id
    end

    def test_delete_payment_link
      stub_request(:delete, 'https://api.mollie.com/v2/payment-links/pl_4Y0eZitmBnQ6IDoMqZQKh')
        .to_return(status: 204, body: GET_PAYMENT_LINK, headers: {})

      payment_link = PaymentLink.delete("pl_4Y0eZitmBnQ6IDoMqZQKh")
      assert_nil payment_link
    end

    def test_list_payment_links
      stub_request(:get, "https://api.mollie.com/v2/payment-links")
        .to_return(status: 200, body: LIST_PAYMENT_LINKS, headers: {})

      payment_links = PaymentLink.all
      assert_equal 3, payment_links.size
      assert_equal "pl_one", payment_links[0].id
      assert_equal "pl_two", payment_links[1].id
      assert_equal "pl_three", payment_links[2].id
    end

    def test_list_payment_link_payments
      stub_request(:get, "https://api.mollie.com/v2/payment-links/pl_4Y0eZitmBnQ6IDoMqZQKh")
        .to_return(status: 200, body: GET_PAYMENT_LINK, headers: {})

      stub_request(:get, "https://api.mollie.com/v2/payment-links/pl_4Y0eZitmBnQ6IDoMqZQKh/payments")
        .to_return(status: 200, body: LIST_PAYMENT_LINK_PAYMENTS, headers: {})

      payment_link = PaymentLink.get("pl_4Y0eZitmBnQ6IDoMqZQKh")
      payments = payment_link.payments

      assert_equal 3, payments.size
      assert_equal "tr_one", payments[0].id
      assert_equal "tr_two", payments[1].id
      assert_equal "tr_three", payments[2].id
    end
  end
end

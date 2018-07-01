require 'helper'

module Mollie
  class CustomerTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:                    'cst_vsKJpSsabw',
        mode:                  'test',
        name:                  'Customer A',
        email:                 'customer@example.org',
        locale:                'nl_NL',
        metadata:              { my_field: 'value' },
        recently_used_methods: 'creditcard',
        created_at:            '2016-04-06T13:23:21.0Z'
      }

      customer = Customer.new(attributes)

      assert_equal 'cst_vsKJpSsabw', customer.id
      assert_equal 'test', customer.mode
      assert_equal 'Customer A', customer.name
      assert_equal 'customer@example.org', customer.email
      assert_equal 'nl_NL', customer.locale
      assert_equal ['creditcard'], customer.recently_used_methods
      assert_equal Time.parse('2016-04-06T13:23:21.0Z'), customer.created_at

      assert_equal 'value', customer.metadata.my_field
      assert_equal nil, customer.metadata.non_existing
    end

    def test_list_mandates
      stub_request(:get, "https://api.mollie.nl/v2/customers/cus-id/mandates")
        .to_return(:status => 200, :body => %{{"_embedded" : { "mandates" : [{"id":"man-id", "customer_id":"cus-id"}]}} }, :headers => {})

      mandates = Customer.new(id: "cus-id").mandates.all

      assert_equal "man-id", mandates.first.id
    end

    def test_create_mandate
      stub_request(:post, "https://api.mollie.nl/v2/customers/cus-id/mandates")
        .with(body: %{{"method":"directdebit"}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "method":"directdebit"}}, :headers => {})

      mandate = Customer.new(id: "cus-id").mandates.create(method: "directdebit")

      assert_equal "my-id", mandate.id
      assert_equal "directdebit", mandate.method
    end

    def test_delete_mandate
      stub_request(:delete, "https://api.mollie.nl/v2/customers/cus-id/mandates/man-id")
        .to_return(:status => 204, :headers => {})

      mandate = Customer.new(id: "cus-id").mandates.delete("man-id")
      assert_equal nil, mandate
    end

    def test_get_mandate
      stub_request(:get, "https://api.mollie.nl/v2/customers/cus-id/mandates/man-id")
        .to_return(:status => 200, :body => %{{"id":"man-id", "customer_id":"cus-id"}}, :headers => {})

      mandate = Customer.new(id: "cus-id").mandates.get("man-id")

      assert_equal "man-id", mandate.id
      assert_equal "cus-id", mandate.customer_id
    end

    def test_list_subscriptions
      stub_request(:get, "https://api.mollie.nl/v2/customers/cus-id/subscriptions")
        .to_return(:status => 200, :body => %{{"_embedded" : {"subscriptions" : [{"id":"sub-id", "customer_id":"cus-id"}]}} }, :headers => {})

      subscriptions = Customer.new(id: "cus-id").subscriptions.all

      assert_equal "sub-id", subscriptions.first.id
    end

    def test_create_subscription
      stub_request(:post, "https://api.mollie.nl/v2/customers/cus-id/subscriptions")
        .with(body: %{{"amount":{"value":1.95,"currency":"EUR"}}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "amount": { "value" : 1.95, "currency": "EUR"}}}, :headers => {})

      subscription = Customer.new(id: "cus-id").subscriptions.create(amount: { value: 1.95, currency: "EUR" })

      assert_equal "my-id", subscription.id
      assert_equal BigDecimal.new("1.95"), subscription.amount.value
    end

    def test_delete_subscription
      stub_request(:delete, "https://api.mollie.nl/v2/customers/cus-id/subscriptions/sub-id")
        .to_return(:status => 204, :headers => {})

      subscription = Customer.new(id: "cus-id").subscriptions.delete("sub-id")
      assert_equal nil, subscription
    end

    def test_get_subscription
      stub_request(:get, "https://api.mollie.nl/v2/customers/cus-id/subscriptions/sub-id")
        .to_return(:status => 200, :body => %{{"id":"sub-id", "customer_id":"cus-id"}}, :headers => {})

      subscription = Customer.new(id: "cus-id").subscriptions.get("sub-id")

      assert_equal "sub-id", subscription.id
      assert_equal "cus-id", subscription.customer_id
    end

    def test_list_payments
      stub_request(:get, "https://api.mollie.nl/v2/customers/cus-id/payments")
        .to_return(:status => 200, :body => %{{"_embedded" : { "payments" : [{"id":"sub-id", "customer_id":"cus-id"}]}}}, :headers => {})

      payments = Customer.new(id: "cus-id").payments.all

      assert_equal "sub-id", payments.first.id
    end

    def test_create_payment
      stub_request(:post, "https://api.mollie.nl/v2/customers/cus-id/payments")
        .with(body: %{{"amount":{"value":1.95,"currency":"EUR"}}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "amount":{ "value" : 1.95, "currency" : "EUR"}}}, :headers => {})

      payment = Customer.new(id: "cus-id").payments.create(amount: { value: 1.95, currency: "EUR" })

      assert_kind_of Mollie::Payment, payment
      assert_equal "my-id", payment.id
      assert_equal BigDecimal.new("1.95"), payment.amount.value
      assert_equal 'EUR', payment.amount.currency
    end
  end
end

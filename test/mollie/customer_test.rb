require 'helper'

module Mollie
  class CustomerTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:         'cst_vsKJpSsabw',
        mode:       'test',
        name:       'Customer A',
        email:      'customer@example.org',
        locale:     'nl_NL',
        metadata:   { my_field: 'value' },
        created_at: '2016-04-06T13:23:21.0Z'
      }

      customer = Customer.new(attributes)

      assert_equal 'cst_vsKJpSsabw', customer.id
      assert_equal 'test', customer.mode
      assert_equal 'Customer A', customer.name
      assert_equal 'customer@example.org', customer.email
      assert_equal 'nl_NL', customer.locale
      assert_equal Time.parse('2016-04-06T13:23:21.0Z'), customer.created_at

      assert_equal 'value', customer.metadata.my_field
      assert_equal nil, customer.metadata.non_existing
    end

    def test_list_mandates
      stub_request(:get, "https://api.mollie.com/v2/customers/cus-id/mandates")
        .to_return(:status => 200, :body => %{{"_embedded" : { "mandates" : [{"id":"man-id", "customer_id":"cus-id"}]}} }, :headers => {})

      mandates = Customer.new(id: "cus-id").mandates

      assert_equal "man-id", mandates.first.id
    end

    def test_list_subscriptions
      stub_request(:get, "https://api.mollie.com/v2/customers/cus-id/subscriptions")
        .to_return(:status => 200, :body => %{{"_embedded" : {"subscriptions" : [{"id":"sub-id", "customer_id":"cus-id"}]}} }, :headers => {})

      subscriptions = Customer.new(id: "cus-id").subscriptions

      assert_equal "sub-id", subscriptions.first.id
    end

    def test_list_payments
      stub_request(:get, "https://api.mollie.com/v2/customers/cus-id/payments")
        .to_return(:status => 200, :body => %{{"_embedded" : { "payments" : [{"id":"sub-id", "customer_id":"cus-id"}]}}}, :headers => {})

      payments = Customer.new(id: "cus-id").payments

      assert_equal "sub-id", payments.first.id
    end
  end
end

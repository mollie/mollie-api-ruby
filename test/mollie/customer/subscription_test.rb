require 'helper'

module Mollie
  class Customer
    class SubscriptionTest < Test::Unit::TestCase
      def test_setting_attributes
        attributes = {
          id:           'sub_rVKGtNd6s3',
          customer_id:  'cst_stTC2WHAuS',
          mode:         'live',
          created_at:   '2016-06-01T12:23:34.0Z',
          status:       'active',
          amount:       { 'value' => '25.00', 'currency' => 'EUR' },
          times:        4,
          times_remaining: 3,
          interval:     '3 months',
          next_payment_date: '2016-09-01',
          description:  'Quarterly payment',
          method:       'creditcard',
          mandate_id:   'mdt_38HS4fsS',
          canceled_at:  '2016-06-01T12:23:34.0Z',
          webhook_url:  'https://example.org/payments/webhook',
          metadata:     { my_field: 'value' },
        }

        subscription = Subscription.new(attributes)

        assert_equal 'sub_rVKGtNd6s3', subscription.id
        assert_equal 'cst_stTC2WHAuS', subscription.customer_id
        assert_equal 'live', subscription.mode
        assert_equal Time.parse('2016-06-01T12:23:34.0Z'), subscription.created_at
        assert_equal 'active', subscription.status
        assert_equal BigDecimal('25.00'), subscription.amount.value
        assert_equal 'EUR', subscription.amount.currency
        assert_equal 4, subscription.times
        assert_equal 3, subscription.times_remaining
        assert_equal '3 months', subscription.interval
        assert_equal Date.parse('2016-09-01'), subscription.next_payment_date
        assert_equal 'Quarterly payment', subscription.description
        assert_equal 'creditcard', subscription.method
        assert_equal 'mdt_38HS4fsS', subscription.mandate_id
        assert_equal Time.parse('2016-06-01T12:23:34.0Z'), subscription.canceled_at
        assert_equal 'https://example.org/payments/webhook', subscription.webhook_url

        assert_equal 'value', subscription.metadata.my_field
        assert_equal nil, subscription.metadata.non_existing
      end

      def test_status_active
        assert Subscription.new(status: Subscription::STATUS_ACTIVE).active?
        assert !Subscription.new(status: 'not-active').active?
      end

      def test_status_pending
        assert Subscription.new(status: Subscription::STATUS_PENDING).pending?
        assert !Subscription.new(status: 'not-pending').pending?
      end

      def test_status_suspended
        assert Subscription.new(status: Subscription::STATUS_SUSPENDED).suspended?
        assert !Subscription.new(status: 'not-suspended').suspended?
      end

      def test_status_canceled
        assert Subscription.new(status: Subscription::STATUS_CANCELED).canceled?
        assert !Subscription.new(status: 'not-canceled').canceled?
      end

      def test_status_completed
        assert Subscription.new(status: Subscription::STATUS_COMPLETED).completed?
        assert !Subscription.new(status: 'not-completed').completed?
      end

      def test_get_subscription
        stub_request(:get, 'https://api.mollie.com/v2/customers/cus-id/subscriptions/sub-id')
          .to_return(status: 200, body: %({"id":"sub-id", "customer_id":"cus-id"}), headers: {})

        subscription = Customer::Subscription.get('sub-id', customer_id: 'cus-id')

        assert_equal 'sub-id', subscription.id
        assert_equal 'cus-id', subscription.customer_id
      end

      def test_create_subscription
        stub_request(:post, 'https://api.mollie.com/v2/customers/cus-id/subscriptions')
          .with(body: %({"amount":{"value":1.95,"currency":"EUR"}}))
          .to_return(status: 201, body: %({"id":"my-id", "amount": { "value" : 1.95, "currency": "EUR"}}), headers: {})

        subscription = Customer::Subscription.create(customer_id: 'cus-id', amount: { value: 1.95, currency: 'EUR' })

        assert_equal 'my-id', subscription.id
        assert_equal BigDecimal('1.95'), subscription.amount.value
      end

      def test_delete_subscription
        stub_request(:delete, 'https://api.mollie.com/v2/customers/cus-id/subscriptions/sub-id')
          .to_return(status: 204, headers: {})

        subscription = Customer::Subscription.delete('sub-id', customer_id: 'cus-id')
        assert_equal nil, subscription
      end

      def test_get_customer
        stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/subscriptions/sub_rVKGtNd6s3')
          .to_return(status: 200, body: %(
            {
                "resource": "subscription",
                "id": "sub_rVKGtNd6s3",
                "customer_id": "cst_8wmqcHMN4U"
            }
          ), headers: {})

        stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U')
          .to_return(status: 200, body: %(
            {
                "resource": "customer",
                "id": "cst_8wmqcHMN4U"
            }
          ), headers: {})

        subscription = Customer::Subscription.get('sub_rVKGtNd6s3', customer_id: 'cst_8wmqcHMN4U')
        customer = subscription.customer
        assert_equal 'cst_8wmqcHMN4U', customer.id
      end

      def test_application_fee
        stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/subscriptions/sub_rVKGtNd6s3')
          .to_return(status: 200, body: %(
            {
              "resource": "subscription",
              "id": "sub_rVKGtNd6s3",
              "application_fee": {
                "amount": {
                  "value": "42.10",
                  "currency": "EUR"
                },
                "description": "Example application fee"
              }
            }
          ), headers: {})

        subscription = Customer::Subscription.get('sub_rVKGtNd6s3', customer_id: 'cst_8wmqcHMN4U')
        assert_equal 42.10, subscription.application_fee.amount.value
        assert_equal'EUR', subscription.application_fee.amount.currency
      end
    end
  end
end

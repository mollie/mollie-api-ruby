require 'helper'

module Mollie
  class Customer
    class SubscriptionTest < Test::Unit::TestCase
      def test_setting_attributes
        attributes = {
          id:           "sub_rVKGtNd6s3",
          customer_id:  "cst_stTC2WHAuS",
          mode:         "live",
          created_at:   "2016-06-01T12:23:34.0Z",
          status:       "active",
          amount:       { "value" => "25.00", "currency" => "EUR" },
          times:        4,
          interval:     "3 months",
          description:  "Quarterly payment",
          method:       "creditcard",
          canceled_at:  "2016-06-01T12:23:34.0Z",
          webhook_url:  "https://example.org/payments/webhook"
        }

        subscription = Subscription.new(attributes)

        assert_equal "sub_rVKGtNd6s3", subscription.id
        assert_equal "cst_stTC2WHAuS", subscription.customer_id
        assert_equal "live", subscription.mode
        assert_equal Time.parse("2016-06-01T12:23:34.0Z"), subscription.created_at
        assert_equal "active", subscription.status
        assert_equal BigDecimal.new("25.00"), subscription.amount.value
        assert_equal "EUR", subscription.amount.currency
        assert_equal 4, subscription.times
        assert_equal "3 months", subscription.interval
        assert_equal "Quarterly payment", subscription.description
        assert_equal "creditcard", subscription.method
        assert_equal Time.parse("2016-06-01T12:23:34.0Z"), subscription.canceled_at
        assert_equal "https://example.org/payments/webhook", subscription.webhook_url
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
    end
  end
end

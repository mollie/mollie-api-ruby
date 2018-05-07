require 'helper'

module Mollie
  class RefundTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:         "re_4qqhO89gsT",
        amount:     { "value" => "5.95", "currency" => "EUR" },
        created_at: "2016-10-08T07:59:53.0Z",
        status:     "pending"
      }

      refund = Refund.new(attributes)

      assert_equal "re_4qqhO89gsT", refund.id
      assert_equal BigDecimal.new("5.95"), refund.amount
      assert_equal "EUR", refund.currency
      assert_equal Time.parse("2016-10-08T07:59:53.0Z"), refund.created_at
      assert_equal Refund::STATUS_PENDING, refund.status
    end

    def test_pending?
      assert Refund.new(status: Refund::STATUS_PENDING).pending?
      assert !Refund.new(status: 'not-pending').pending?
    end

    def test_processing?
      assert Refund.new(status: Refund::STATUS_PROCESSING).processing?
      assert !Refund.new(status: 'not-processing').processing?
    end

    def test_refunded?
      assert Refund.new(status: Refund::STATUS_REFUNDED).refunded?
      assert !Refund.new(status: 'not-refunded').refunded?
    end
  end
end

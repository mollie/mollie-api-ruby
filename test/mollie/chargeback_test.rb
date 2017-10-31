require 'helper'

module Mollie
  class ChargebackTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:                  "re_4qqhO89gsT",
        payment:             {
          id: "tr_WDqYK6vllg",
        },
        amount:              "5.95",
        chargeback_datetime: "2016-10-08T07:59:53.0Z",
        reversed_datetime:   "2016-10-08T07:59:53.0Z",
      }

      chargeback = Chargeback.new(attributes)

      assert_equal "re_4qqhO89gsT", chargeback.id
      assert_equal BigDecimal.new("5.95"), chargeback.amount
      assert_kind_of Payment, chargeback.payment
      assert_equal Time.parse("2016-10-08T07:59:53.0Z"), chargeback.chargeback_datetime
      assert_equal Time.parse("2016-10-08T07:59:53.0Z"), chargeback.reversed_datetime
    end

    def test_payment
      assert_equal "pay-id", Chargeback.new(payment: "pay-id").payment
      assert_equal "pay-id", Chargeback.new(payment: {id: "pay-id"}).payment.id
    end

    def test_reversed?
      assert Chargeback.new(reversed_datetime: "2016-10-08T07:59:53.0Z").reversed?
      assert !Chargeback.new(reversed_datetime: nil).reversed?
    end
  end
end

require 'helper'

module Mollie
  class ChargebackTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:          "re_4qqhO89gsT",
        amount:      { "value" => "5.95", "currency" => "EUR" },
        created_at:  "2016-10-08T07:59:53.0Z",
        reversed_at: "2016-10-08T07:59:53.0Z",
        payment_id:  "tr_WDqYK6vllg",
        settlement_amount: { "value" => "-5.95", "currency" => "EUR" }
      }

      chargeback = Chargeback.new(attributes)

      assert_equal "re_4qqhO89gsT", chargeback.id
      assert_equal BigDecimal.new("5.95"), chargeback.amount.value
      assert_equal "EUR", chargeback.amount.currency
      assert_equal Time.parse("2016-10-08T07:59:53.0Z"), chargeback.created_at
      assert_equal Time.parse("2016-10-08T07:59:53.0Z"), chargeback.reversed_at
      assert_equal "tr_WDqYK6vllg", chargeback.payment_id
      assert_equal BigDecimal.new("-5.95"), chargeback.settlement_amount.value
      assert_equal "EUR", chargeback.settlement_amount.currency
    end


    def test_reversed?
      assert Chargeback.new(reversed_at: "2016-10-08T07:59:53.0Z").reversed?
      assert !Chargeback.new(reversed_at: nil).reversed?
    end
  end
end

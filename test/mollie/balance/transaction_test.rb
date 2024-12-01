require 'helper'

module Mollie
  class Balance
    class TransactionTest < Test::Unit::TestCase
      def test_setting_attributes
        attributes = {
          id: "baltr_QM24QwzUWR4ev4Xfgyt29A",
          type: "refund",
          result_amount: { "value" => "-10.25", "currency" => "EUR" },
          initial_amount: { "value" => "-10.00", "currency" => "EUR" },
          deductions: { "value" => "0.25", "currency" => "EUR" },
          context: {
            "paymentId" => "tr_7UhSN1zuXS",
            "refundId" => "re_4qqhO89gsT"
          },
          created_at: "2021-01-10T12:06:28+00:00"
        }

        balance = Balance::Transaction.new(attributes)

        assert_equal "baltr_QM24QwzUWR4ev4Xfgyt29A", balance.id
        assert_equal "refund", balance.type
        assert_equal BigDecimal("-10.25"), balance.result_amount.value
        assert_equal "EUR", balance.result_amount.currency
        assert_equal BigDecimal("-10.00"), balance.initial_amount.value
        assert_equal "EUR", balance.initial_amount.currency
        assert_equal BigDecimal("0.25"), balance.deductions.value
        assert_equal "EUR", balance.deductions.currency
        assert_equal "tr_7UhSN1zuXS", balance.context.paymentId
        assert_equal "re_4qqhO89gsT", balance.context.refundId
        assert_equal Time.parse("2021-01-10T12:06:28+00:00"), balance.created_at
      end
    end
  end
end

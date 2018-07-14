require 'helper'

module Mollie
  class AmountTest  < Test::Unit::TestCase
    def test_value
      amount = Amount.new('value' => '42.10', 'currency' => 'EUR')
      assert_equal 0.421e2, amount.value
    end

    def test_currency
      amount = Amount.new('currency' => 'EUR')
      assert_equal 'EUR', amount.currency
    end

    def test_to_hash
      amount = Amount.new('value' => '42.10', 'currency' => 'EUR')

      assert_equal(
        { value: '42.10', currency: 'EUR' },
        amount.to_h
      )
    end

    def test_nil
      amount = Mollie::Amount.new(nil)
      assert_nil amount.value
      assert_nil amount.currency
    end
  end
end

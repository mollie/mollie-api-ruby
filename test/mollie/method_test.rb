require 'helper'

module Mollie
  class MethodTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:          'creditcard',
        description: 'Credit card',
        minimum_amount: { value: '0.01', currency: 'EUR' },
        maximum_amount: { value: '2000.00', currency: 'EUR' },
        status: 'approved',
        image: {
          'size1x' => 'https://www.mollie.com/external/icons/payment-methods/creditcard.png',
          'size2x' => 'https://www.mollie.com/external/icons/payment-methods/creditcard%402x.png',
          'svg'    => 'https://www.mollie.com/external/icons/payment-methods/creditcard.svg'
        }
      }

      method = Method.new(attributes)

      assert_equal 'creditcard', method.id
      assert_equal 'Credit card', method.description
      assert_equal BigDecimal('0.01'), method.minimum_amount.value
      assert_equal 'EUR', method.minimum_amount.currency
      assert_equal BigDecimal('2000.00'), method.maximum_amount.value
      assert_equal 'EUR', method.maximum_amount.currency
      assert_equal 'approved', method.status
      assert_equal 'https://www.mollie.com/external/icons/payment-methods/creditcard.png', method.normal_image
      assert_equal 'https://www.mollie.com/external/icons/payment-methods/creditcard%402x.png', method.bigger_image
      assert_equal 'https://www.mollie.com/external/icons/payment-methods/creditcard.svg', method.image['svg']
    end

    def test_all_available
      stub_request(:get, 'https://api.mollie.com/v2/methods/all')
        .to_return(status: 200, body: read_fixture('methods/all.json'), headers: {})

      available_methods = Method.all_available
      assert_equal 3, available_methods.size

      ideal_method = available_methods.first
      assert_equal "pending-boarding", ideal_method.status
    end

    def test_pricing
      stub_request(:get, 'https://api.mollie.com/v2/methods/creditcard?include=pricing')
        .to_return(status: 200, body: read_fixture('methods/get-includes-pricing.json'), headers: {})

      creditcard = Method.get('creditcard', include: 'pricing')
      creditcard_pricing = creditcard.pricing

      assert_equal 3, creditcard_pricing.size
      assert_equal 'Commercial & non-European cards', creditcard_pricing.first.description
      assert_equal BigDecimal('0.25'), creditcard_pricing.first.fixed.value
      assert_equal 'EUR', creditcard_pricing.first.fixed.currency
      assert_equal '2.8', creditcard_pricing.first.variable
      assert_equal 'other', creditcard_pricing.first.fee_region
    end
  end
end

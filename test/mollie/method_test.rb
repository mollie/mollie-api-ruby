require 'helper'

module Mollie
  class MethodTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:          'creditcard',
        description: 'Credit card',
        image: {
          'size1x' => 'https://www.mollie.com/external/icons/payment-methods/creditcard.png',
          'size2x' => 'https://www.mollie.com/external/icons/payment-methods/creditcard%402x.png',
          'svg'    => 'https://www.mollie.com/external/icons/payment-methods/creditcard.svg'
        }
      }

      method = Method.new(attributes)

      assert_equal 'creditcard', method.id
      assert_equal 'Credit card', method.description
      assert_equal 'https://www.mollie.com/external/icons/payment-methods/creditcard.png', method.normal_image
      assert_equal 'https://www.mollie.com/external/icons/payment-methods/creditcard%402x.png', method.bigger_image
      assert_equal 'https://www.mollie.com/external/icons/payment-methods/creditcard.svg', method.image['svg']
    end
  end
end

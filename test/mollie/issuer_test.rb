require 'helper'

module Mollie
  class IssuerTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:     'ideal_ABNANL2A',
        name:   'ABN AMRO',
        method: 'ideal'
      }

      customer = Issuer.new(attributes)

      assert_equal 'ideal_ABNANL2A', customer.id
      assert_equal 'ABN AMRO', customer.name
      assert_equal 'ideal', customer.method
    end
  end
end

require 'helper'

module Mollie
  class CustomerTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:                    'cst_vsKJpSsabw',
        mode:                  'test',
        name:                  'Customer A',
        email:                 'customer@example.org',
        locale:                'nl_NL',
        metadata:              { my_field: 'value' },
        recently_used_methods: 'creditcard',
        created_datetime:      '2016-04-06T13:23:21.0Z'
      }

      customer = Customer.new(attributes)

      assert_equal 'cst_vsKJpSsabw', customer.id
      assert_equal 'test', customer.mode
      assert_equal 'Customer A', customer.name
      assert_equal 'customer@example.org', customer.email
      assert_equal 'nl_NL', customer.locale
      assert_equal ['creditcard'], customer.recently_used_methods
      assert_equal Time.parse('2016-04-06T13:23:21.0Z'), customer.created_datetime

      assert_equal 'value', customer.metadata.my_field
      assert_equal nil, customer.metadata.non_existing
    end
  end
end

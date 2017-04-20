require 'helper'

module Mollie
  module API
    class UtilTest < Test::Unit::TestCase

      def test_nested_underscore_keys_for_nested_array_with_string
        payload  = { "recentlyUsedMethods" => ["banktransfer"] }
        expected = { "recently_used_methods" => ["banktransfer"] }
        assert_equal(expected, Util.nested_underscore_keys(payload))
      end

      def test_nested_underscore_keys_for_nested_array_with_string2
        payload  = { myKey: [{ a: 123, myNestedKey: 456 }] }
        expected = { "my_key" => [{ "a" => 123, "my_nested_key" => 456 }] }
        assert_equal(expected, Util.nested_underscore_keys(payload))
      end

      def test_nested_openstruct_for_nested_array
        payload = {
            periods: {
                "2015" => {
                    "11" => {
                        revenue: [
                            {
                                description: "iDEAL"
                            }
                        ]
                    }
                }
            }
        }

        result  = Util.nested_openstruct(payload)

        assert_kind_of OpenStruct, result
        assert_kind_of OpenStruct, result.periods
        assert_kind_of OpenStruct, result.periods[:'2015']
        assert_kind_of OpenStruct, result.periods[:'2015'][:'11']
        assert_kind_of Array, result.periods[:'2015'][:'11'].revenue
        assert_kind_of OpenStruct, result.periods[:'2015'][:'11'].revenue[0]

        assert_equal "iDEAL", result.periods[:'2015'][:'11'].revenue[0].description
      end
    end
  end
end

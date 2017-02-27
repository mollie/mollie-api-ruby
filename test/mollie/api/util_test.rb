require 'helper'

module Mollie
  module API
    class UtilTest < Test::Unit::TestCase

      def test_nested_underscore_keys_for_nested_array_with_string
        payload  = { "recentlyUsedMethods" => ["banktransfer"] }
        expected = { "recently_used_methods" => ["banktransfer"] }
        assert_equal(expected, Util.nested_underscore_keys(payload))
      end

      def test_nested_underscore_keys_for_nested_arry_with_string2
        payload  = { myKey: [{ a: 123, myNestedKey: 456 }] }
        expected = { "my_key" => [{ "a" => 123, "my_nested_key" => 456 }] }
        assert_equal(expected, Util.nested_underscore_keys(payload))
      end
    end
  end
end

require 'helper'

module Mollie
  module API
    module Object
      class TestObject < Base
        attr_accessor :my_field
      end

      class BaseTest < Test::Unit::TestCase
        def test_setting_attributes
          attributes = {my_field: "my value", extra_field: "extra"}
          object = TestObject.new(attributes)

          assert_equal "my value", object.my_field
          assert_equal attributes, object.attributes
        end
      end
    end
  end
end

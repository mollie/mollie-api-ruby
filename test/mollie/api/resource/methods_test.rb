require 'helper'

module Mollie
  module API
    module Resource
      class MethodsTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Method, Methods.new(nil).resource_object
        end
      end
    end
  end
end

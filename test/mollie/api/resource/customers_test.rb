require 'helper'

module Mollie
  module API
    module Resource
      class CustomersTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Customer, Customers.new(nil).resource_object
        end
      end
    end
  end
end

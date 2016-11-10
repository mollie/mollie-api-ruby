require 'helper'

module Mollie
  module API
    module Resource
      class Customers
        class MandatesTest < Test::Unit::TestCase
          def test_resource_object
            assert_equal Object::Mandate, Mandates.new(nil).resource_object
          end

          def test_resource_name_and_with
            mandates = Mandates.new(nil).with("customer-id")
            assert_equal "customers/customer-id/mandates", mandates.resource_name

            mandates = Mandates.new(nil).with(Object::Customer.new(id: "customer-id"))
            assert_equal "customers/customer-id/mandates", mandates.resource_name
          end
        end
      end
    end
  end
end

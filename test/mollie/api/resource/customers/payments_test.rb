require 'helper'

module Mollie
  module API
    module Resource
      class Customers
        class PaymentsTest < Test::Unit::TestCase
          def test_resource_object
            assert_equal Object::Payment, Payments.new(nil).resource_object
          end

          def test_resource_name_and_with
            payments = Payments.new(nil).with("customer-id")
            assert_equal "customers/customer-id/payments", payments.resource_name

            payments = Payments.new(nil).with(Object::Customer.new(id: "customer-id"))
            assert_equal "customers/customer-id/payments", payments.resource_name
          end
        end
      end
    end
  end
end

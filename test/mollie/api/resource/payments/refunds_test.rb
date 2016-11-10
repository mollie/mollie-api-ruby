require 'helper'

module Mollie
  module API
    module Resource
      class Payments
        class RefundsTest < Test::Unit::TestCase
          def test_resource_object
            assert_equal Object::Payment::Refund, Refunds.new(nil).resource_object
          end

          def test_resource_name_and_with
            refunds = Refunds.new(nil).with("payment-id")
            assert_equal "payments/payment-id/refunds", refunds.resource_name

            refunds = Refunds.new(nil).with(Object::Payment.new(id: "payment-id"))
            assert_equal "payments/payment-id/refunds", refunds.resource_name
          end
        end
      end
    end
  end
end

require 'helper'

module Mollie
  module API
    module Resource
      class Customers
        class SubscriptionsTest < Test::Unit::TestCase
          def test_resource_object
            assert_equal Object::Subscription, Subscriptions.new(nil).resource_object
          end

          def test_resource_name_and_with
            subscriptions = Subscriptions.new(nil).with("customer-id")
            assert_equal "customers/customer-id/subscriptions", subscriptions.resource_name

            subscriptions = Subscriptions.new(nil).with(Object::Customer.new(id: "customer-id"))
            assert_equal "customers/customer-id/subscriptions", subscriptions.resource_name
          end
        end
      end
    end
  end
end

require 'open-uri'

module Mollie
  module API
    module Resource
      class Customers
        class Subscriptions < Base
          @parent_id = nil

          def resource_object
            Mollie::API::Object::Subscription
          end

          def resource_name
            parent_id = URI::encode(@parent_id)
            "customers/#{parent_id}/subscriptions"
          end

          def with(customer)
            @parent_id = customer.id
            self
          end
        end
      end
    end
  end
end

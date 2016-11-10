require 'open-uri'

module Mollie
  module API
    module Resource
      class Customers
        class Subscriptions < Base
          @customer_id = nil

          def resource_object
            Object::Subscription
          end

          def resource_name
            customer_id = URI::encode(@customer_id)
            "customers/#{customer_id}/subscriptions"
          end

          def with(customer_or_id)
            @customer_id = customer_or_id.is_a?(Object::Customer) ? customer_or_id.id : customer_or_id
            self
          end
        end
      end
    end
  end
end

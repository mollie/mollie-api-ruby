require 'open-uri'

module Mollie
  module API
    module Resource
      class Customers
        class Mandates < Base
          @customer_id = nil

          def resource_object
            Object::Customer::Mandate
          end

          def resource_name
            customer_id = URI::encode(@customer_id)
            "customers/#{customer_id}/mandates"
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

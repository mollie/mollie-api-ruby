require 'open-uri'

module Mollie
  module API
    module Resource
      class Customers
        class Mandates < Base
          @customer_id = nil

          def getResourceObject
            Mollie::API::Object::Mandate
          end

          def getResourceName
            customer_id = URI::encode(@customer_id)
            "customers/#{customer_id}/mandates"
          end

          def with(customer)
            @customer_id = customer.id
            self
          end
        end
      end
    end
  end
end

require 'open-uri'

module Mollie
  module API
    module Resource
      class Settlements
        class Payments < Base
          @settlement_id = nil

          def resource_object
            Object::Payment
          end

          def resource_name
            settlement_id = URI::encode(@settlement_id)
            "settlements/#{settlement_id}/payments"
          end

          def with(settlement_or_id)
            @settlement_id = settlement_or_id.is_a?(Object::Settlement) ? settlement_or_id.id : settlement_or_id
            self
          end
        end
      end
    end
  end
end

require 'open-uri'

module Mollie
  module API
    module Resource
      class Payments
        class Refunds < Base
          @payment_id = nil

          def resource_object
            Object::Payment::Refund
          end

          def resource_name
            payment_id = URI::encode(@payment_id)
            "payments/#{payment_id}/refunds"
          end

          def with(payment_or_id)
            @payment_id = payment_or_id.is_a?(Object::Payment) ? payment_or_id.id : payment_or_id
            self
          end
        end
      end
    end
  end
end

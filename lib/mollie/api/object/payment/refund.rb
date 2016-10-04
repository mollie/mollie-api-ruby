module Mollie
  module API
    module Object
      class Payment
        class Refund < Base
          attr_accessor :id,
                        :amount_refunded,
                        :amount_remaining,
                        :payment,
                        :refunded_datetime

          def refunded_datetime=(refunded_datetime)
            @refunded_datetime = Time.parse(refunded_datetime) rescue nil
          end

          def amount_remaining=(amount_remaining)
            @amount_remaining = BigDecimal.new(amount_remaining) if amount_remaining
          end

          def amount_refunded=(amount_refunded)
            @amount_refunded = BigDecimal.new(amount_refunded) if amount_refunded
          end

          def payment=(payment)
            @payment = Payment.new(payment)
          end
        end
      end
    end
  end
end

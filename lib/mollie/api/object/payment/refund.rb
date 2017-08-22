module Mollie
  module API
    module Object
      class Payment
        class Refund < Base
          STATUS_QUEUED     = "queued"
          STATUS_PENDING    = "pending"
          STATUS_PROCESSING = "processing"
          STATUS_REFUNDED   = "refunded"

          attr_accessor :id,
                        :payment,
                        :amount,
                        :status,
                        :refunded_datetime
          def queued?
            status == STATUS_QUEUED
          end
          
          def pending?
            status == STATUS_PENDING
          end

          def processing?
            status == STATUS_PROCESSING
          end

          def refunded?
            status == STATUS_REFUNDED
          end

          def refunded_datetime=(refunded_datetime)
            @refunded_datetime = Time.parse(refunded_datetime) rescue nil
          end

          def amount=(amount)
            @amount = BigDecimal.new(amount.to_s) if amount
          end

          def payment=(payment)
            @payment = Payment.new(payment)
          end
        end
      end
    end
  end
end

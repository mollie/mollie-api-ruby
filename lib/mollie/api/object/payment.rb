module Mollie
  module API
    module Object
      class Payment < Base
        STATUS_OPEN      = "open"
        STATUS_CANCELLED = "cancelled"
        STATUS_EXPIRED   = "expired"
        STATUS_PAID      = "paid"
        STATUS_PAIDOUT   = "paidout"
        STATUS_FAILED    = "failed"
        STATUS_REFUNDED  = "refunded"

        RECURRINGTYPE_NONE      = nil
        RECURRINGTYPE_FIRST     = "first"
        RECURRINGTYPE_RECURRING = "recurring"

        attr_accessor :id,
                      :status,
                      :mode,
                      :amount,
                      :description,
                      :method,
                      :created_datetime,
                      :paid_datetime,
                      :expired_datetime,
                      :cancelled_datetime,
                      :customer_id,
                      :recurring_type,
                      :mandate_id,
                      :subscription_id,
                      :settlement_id,
                      :metadata,
                      :details,
                      :links

        def open?
          @status == STATUS_OPEN
        end

        def cancelled?
          @status == STATUS_CANCELLED
        end

        def expired?
          @status == STATUS_EXPIRED
        end

        def paid?
          !@paid_datetime.nil?
        end

        def paidout?
          @status == STATUS_PAIDOUT
        end

        def refunded?
          @status == STATUS_REFUNDED
        end

        def payment_url
          @links && @links.payment_url
        end
      end
    end
  end
end

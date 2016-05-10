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

        RECURRINGTYPE_NONE      = nil
        RECURRINGTYPE_FIRST     = "first"
        RECURRINGTYPE_RECURRING = "recurring"

        attr_accessor :id,
                      :status,
                      :mode,
                      :amount,
                      :description,
                      :method,
                      :createdDatetime,
                      :paidDatetime,
                      :expiredDatetime,
                      :cancelledDatetime,
                      :customerId,
                      :recurringType,
                      :mandateId,
                      :settlementId,
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
          !@paidDatetime.nil?
        end

        def paidout?
          @status == STATUS_PAIDOUT
        end

        def getPaymentUrl
          @links && @links.paymentUrl
        end

        alias_method :payment_url, :getPaymentUrl
      end
    end
  end
end

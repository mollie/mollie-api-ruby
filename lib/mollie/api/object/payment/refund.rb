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
        end
      end
    end
  end
end

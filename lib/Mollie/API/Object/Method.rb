module Mollie
  module API
    module Object
      class Method < Base
        IDEAL        = "ideal"
        CREDITCARD   = "creditcard"
        MISTERCASH   = "mistercash"
        SOFORT       = "sofort"
        BANKTRANSFER = "banktransfer"
        DIRECTDEBIT  = "directdebit"
        BITCOIN      = "bitcoin"
        PAYPAL       = "paypal"
        BELFIUS      = "belfius"
        PAYSAFECARD  = "paysafecard"

        attr_accessor :id,
                      :description,
                      :amount,
                      :image

        def getMinimumAmount
          @amount.minimum
        end

        def getMaximumAmount
          @amount.maximum
        end
      end
    end
  end
end

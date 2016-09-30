module Mollie
  module API
    module Object
      class Method < Base
        IDEAL             = "ideal"
        CREDITCARD        = "creditcard"
        MISTERCASH        = "mistercash"
        SOFORT            = "sofort"
        BANKTRANSFER      = "banktransfer"
        DIRECTDEBIT       = "directdebit"
        BITCOIN           = "bitcoin"
        PAYPAL            = "paypal"
        BELFIUS           = "belfius"
        PAYSAFECARD       = "paysafecard"
        PODIUMCADEAUKAART = "podiumcadeaukaart"

        attr_accessor :id,
                      :description,
                      :amount,
                      :image

        def minimum_amount
          @amount.minimum
        end

        def maximum_amount
          @amount.maximum
        end
      end
    end
  end
end

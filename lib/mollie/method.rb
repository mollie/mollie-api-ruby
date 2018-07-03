module Mollie
  class Method < Base
    BANCONTACT    = "bancontact"
    BANKTRANSFER  = "banktransfer"
    BELFIUS       = "belfius"
    BITCOIN       = "bitcoin"
    CREDITCARD    = "creditcard"
    DIRECTDEBIT   = "directdebit"
    EPS           = "eps"
    GIFTCARD      = "giftcard"
    GIROPAY       = "giropay"
    IDEAL         = "ideal"
    INGHOMEPAY    = "inghomepay"
    KBC           = "kbc"
    PAYPAL        = "paypal"
    PAYSAFECARD   = "paysafecard"
    SOFORT        = "sofort"

    attr_accessor :id,
                  :description,
                  :image,
                  :issuers

    def normal_image
      image['size1x']
    end

    def bigger_image
      image['size2x']
    end
  end
end

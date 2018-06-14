module Mollie
  class Method < Base
    IDEAL             = "ideal"
    CREDITCARD        = "creditcard"
    BANCONTACT        = "bancontact"
    SOFORT            = "sofort"
    BANKTRANSFER      = "banktransfer"
    DIRECTDEBIT       = "directdebit"
    BITCOIN           = "bitcoin"
    PAYPAL            = "paypal"
    KBC               = "kbc"
    BELFIUS           = "belfius"
    PAYSAFECARD       = "paysafecard"
    PODIUMCADEAUKAART = "podiumcadeaukaart"
    GIFTCARD          = "giftcard"
    INGHOMEPAY        = "inghomepay"

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

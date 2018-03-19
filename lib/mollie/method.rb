module Mollie
  class Method < Base
    IDEAL             = "ideal"
    CREDITCARD        = "creditcard"
    MISTERCASH        = "mistercash"
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
                  :amount,
                  :image,
                  :issuers

    def normal_image
      image['normal']
    end

    def bigger_image
      image['bigger']
    end

    def minimum_amount
      BigDecimal.new(amount['minimum'].to_s)
    end

    def maximum_amount
      BigDecimal.new(amount['maximum'].to_s)
    end
  end
end

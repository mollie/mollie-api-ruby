module Mollie
  class Method < Base
    BANCONTACT     = 'bancontact'.freeze
    BANKTRANSFER   = 'banktransfer'.freeze
    BELFIUS        = 'belfius'.freeze
    BITCOIN        = 'bitcoin'.freeze
    CREDITCARD     = 'creditcard'.freeze
    DIRECTDEBIT    = 'directdebit'.freeze
    EPS            = 'eps'.freeze
    GIFTCARD       = 'giftcard'.freeze
    GIROPAY        = 'giropay'.freeze
    IDEAL          = 'ideal'.freeze
    INGHOMEPAY     = 'inghomepay'.freeze
    KBC            = 'kbc'.freeze
    PAYPAL         = 'paypal'.freeze
    PAYSAFECARD    = 'paysafecard'.freeze
    SOFORT         = 'sofort'.freeze
    KLARNASLICEIT  = 'klarnasliceit'.freeze
    KLARNAPAYLATER = 'klarnapaylater'.freeze

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

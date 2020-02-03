module Mollie
  class Method < Base
    APPLEPAY       = 'applepay'.freeze
    BANCONTACT     = 'bancontact'.freeze
    BANKTRANSFER   = 'banktransfer'.freeze
    BELFIUS        = 'belfius'.freeze
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
    PRZELEWY24     = 'przelewy24'.freeze
    SOFORT         = 'sofort'.freeze
    KLARNASLICEIT  = 'klarnasliceit'.freeze
    KLARNAPAYLATER = 'klarnapaylater'.freeze

    attr_accessor :id,
                  :description,
                  :minimum_amount,
                  :maximum_amount,
                  :image,
                  :issuers,
                  :pricing

    def minimum_amount=(minimum_amount)
      @minimum_amount = Mollie::Amount.new(minimum_amount)
    end

    def maximum_amount=(maximum_amount)
      @maximum_amount = Mollie::Amount.new(maximum_amount)
    end

    def normal_image
      image['size1x']
    end

    def bigger_image
      image['size2x']
    end

    def pricing=(pricing)
      @pricing = pricing.map do |price|
        OpenStruct.new(
          description: price['description'],
          fixed: Mollie::Amount.new(price['fixed']),
          variable: price['variable'],
          fee_region: price['fee_region']
        )
      end
    end
  end
end

module Mollie
  class Method < Base
    ALMA           = 'alma'.freeze
    APPLEPAY       = 'applepay'.freeze
    BACS           = 'bacs'.freeze
    BANCONTACT     = 'bancontact'.freeze
    BANCOMAT_PAY   = 'bancomatpay'.freeze
    BANKTRANSFER   = 'banktransfer'.freeze
    BELFIUS        = 'belfius'.freeze
    BILLIE         = 'billie'.freeze
    BILLINK        = 'billink'.freeze
    BIZUM          = 'bizum'.freeze
    BLIK           = 'blik'.freeze
    CREDITCARD     = 'creditcard'.freeze
    DIRECTDEBIT    = 'directdebit'.freeze
    EPS            = 'eps'.freeze
    GIFTCARD       = 'giftcard'.freeze
    GIROPAY        = 'giropay'.freeze
    IDEAL          = 'ideal'.freeze
    IN3            = 'in3'.freeze
    INGHOMEPAY     = 'inghomepay'.freeze
    KBC            = 'kbc'.freeze
    MBWAY          = 'mbway'.freeze
    MOBILEPAY      = 'mobilepay'.freeze
    MULTIBANCO     = 'multibanco'.freeze
    MYBANK         = 'mybank'.freeze
    PAYBYBANK      = 'paybybank'.freeze
    PAYPAL         = 'paypal'.freeze
    PAYSAFECARD    = 'paysafecard'.freeze
    POINTOFSALE    = 'pointofsale'.freeze
    PRZELEWY24     = 'przelewy24'.freeze
    RIVERTY        = 'riverty'.freeze
    SOFORT         = 'sofort'.freeze
    SATISPAY       = 'satispay'.freeze
    SWISH          = 'swish'.freeze
    TRUSTLY        = 'trustly'.freeze
    TWINT          = 'twint'.freeze
    VIPPS          = 'vipps'.freeze
    VOUCHER        = 'voucher'.freeze
    WERO           = 'wero'.freeze
    KLARNA         = 'klarna'.freeze
    KLARNASLICEIT  = 'klarnasliceit'.freeze
    KLARNAPAYLATER = 'klarnapaylater'.freeze

    attr_accessor :id,
                  :description,
                  :minimum_amount,
                  :maximum_amount,
                  :image,
                  :issuers,
                  :pricing,
                  :status

    def self.all_available(options = {})
      response = Client.instance.perform_http_call("GET", "methods", "all", {}, options)
      Mollie::List.new(response, Mollie::Method)
    end

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

module Mollie
  class Amount < Base
    attr_accessor :value, :currency

    def initialize(attributes)
      super unless attributes.nil?
    end

    def value=(val)
      @value = BigDecimal(val.to_s)
    end

    def to_h
      {
        value: attributes['value'],
        currency: attributes['currency']
      }
    end
  end
end

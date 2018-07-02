module Mollie
  class Amount < Base
    attr_accessor :value, :currency

    def initialize(attributes)
      super unless attributes.nil?
    end

    def value=(net)
      @value = BigDecimal.new(net.to_s)
    end
  end
end

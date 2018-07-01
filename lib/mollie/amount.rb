module Mollie
  class Amount < Base
    attr_accessor :value, :currency

    def value=(net)
      @value = BigDecimal.new(net.to_s)
    end
  end
end

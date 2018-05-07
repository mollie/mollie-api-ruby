module Mollie
  class Chargeback < Base

    attr_accessor :id,
                  :payment,
                  :amount,
                  :currency,
                  :settlement_amount,
                  :settlement_currency,
                  :created_at,
                  :settlement_id,
                  :payment_id,
                  :reversed_at


    def reversed?
      !!reversed_at
    end

    def reversed_at=(reversed_at)
      @reversed_at = Time.parse(reversed_at) rescue nil
    end

    def created_at=(created_at)
      @created_at = Time.parse(created_at) rescue nil
    end

    def amount=(amount)
      if amount
        @amount   = BigDecimal.new(amount['value'].to_s)
        @currency = amount['currency']
      end
    end

    def settlement_amount=(settlement_amount)
      if settlement_amount
        @settlement_amount   = BigDecimal.new(settlement_amount['value'].to_s)
        @settlement_currency = settlement_amount['currency']
      end
    end
  end
end

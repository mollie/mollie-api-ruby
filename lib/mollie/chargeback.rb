module Mollie
  class Chargeback < Base

    attr_accessor :id,
                  :payment,
                  :amount,
                  :settlement_amount,
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
      @amount = Mollie::Amount.new(amount)
    end

    def settlement_amount=(settlement_amount)
      @settlement_amount = Mollie::Amount.new(settlement_amount)
    end
  end
end

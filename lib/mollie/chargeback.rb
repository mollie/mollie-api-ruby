module Mollie
  class Chargeback < Base

    attr_accessor :id,
                  :payment,
                  :amount,
                  :settlement_amount,
                  :created_at,
                  :payment_id,
                  :reversed_at,
                  :_links

    alias_method :links, :_links

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

    def payment(options = {})
      Payment.get(payment_id, options)
    end

  end
end

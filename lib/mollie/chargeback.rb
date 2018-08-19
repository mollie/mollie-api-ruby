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

    alias links _links

    def reversed?
      !!reversed_at
    end

    def reversed_at=(reversed_at)
      @reversed_at = begin
                       Time.parse(reversed_at)
                     rescue StandardError
                       nil
                     end
    end

    def created_at=(created_at)
      @created_at = begin
                      Time.parse(created_at)
                    rescue StandardError
                      nil
                    end
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

    def settlement(options = {})
      settlement_id = Util.extract_id(links, 'settlement')
      return if settlement_id.nil?
      Settlement.get(settlement_id, options)
    end
  end
end

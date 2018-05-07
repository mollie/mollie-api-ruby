module Mollie
  class Refund < Base
    STATUS_QUEUED     = "queued"
    STATUS_PENDING    = "pending"
    STATUS_PROCESSING = "processing"
    STATUS_REFUNDED   = "refunded"

    attr_accessor :id,
                  :payment,
                  :amount,
                  :currency,
                  :settlement_amount,
                  :settlement_currency,
                  :status,
                  :payment_id,
                  :created_at

    def queued?
      status == STATUS_QUEUED
    end

    def pending?
      status == STATUS_PENDING
    end

    def processing?
      status == STATUS_PROCESSING
    end

    def refunded?
      status == STATUS_REFUNDED
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

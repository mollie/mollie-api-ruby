module Mollie
  class Refund < Base
    STATUS_QUEUED     = "queued"
    STATUS_PENDING    = "pending"
    STATUS_PROCESSING = "processing"
    STATUS_REFUNDED   = "refunded"
    STATUS_FAILED     = "failed"

    attr_accessor :id,
                  :amount,
                  :settlement_amount,
                  :status,
                  :payment_id,
                  :description,
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

    def failed?
      status == STATUS_FAILED
    end

    def amount=(amount)
      @amount = Amount.new(amount)
    end

    def settlement_amount=(settlement_amount)
      @settlement_amount = Amount.new(settlement_amount)
    end

    def created_at=(created_at)
      @created_at = Time.parse(created_at) rescue nil
    end

    def payment(options = {})
      Payment.get(payment_id, options)
    end
  end
end

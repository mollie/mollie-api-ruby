module Mollie
  class Refund < Base
    STATUS_QUEUED     = 'queued'.freeze
    STATUS_PENDING    = 'pending'.freeze
    STATUS_PROCESSING = 'processing'.freeze
    STATUS_REFUNDED   = 'refunded'.freeze
    STATUS_FAILED     = 'failed'.freeze

    attr_accessor :id,
                  :amount,
                  :settlement_amount,
                  :status,
                  :payment_id,
                  :description,
                  :created_at,
                  :_links

    alias links _links

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
      @created_at = begin
                      Time.parse(created_at)
                    rescue StandardError
                      nil
                    end
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

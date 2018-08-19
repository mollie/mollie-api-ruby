module Mollie
  class Settlement < Base
    STATUS_OPEN    = 'open'.freeze
    STATUS_PENDING = 'pending'.freeze
    STATUS_PAIDOUT = 'paidout'.freeze
    STATUS_FAILED  = 'failed'.freeze

    attr_accessor :id,
                  :reference,
                  :created_at,
                  :settled_at,
                  :status,
                  :amount,
                  :periods,
                  :invoice_id,
                  :_links

    alias links _links

    def self.open(options = {})
      get('open', options)
    end

    def self.next(options = {})
      get('next', options)
    end

    def open?
      status == STATUS_OPEN
    end

    def pending?
      status == STATUS_PENDING
    end

    def paidout?
      status == STATUS_PAIDOUT
    end

    def failed?
      status == STATUS_FAILED
    end

    def created_at=(created_at)
      @created_at = begin
                      Time.parse(created_at.to_s)
                    rescue StandardError
                      nil
                    end
    end

    def settled_at=(settled_at)
      @settled_at = begin
                      Time.parse(settled_at.to_s)
                    rescue StandardError
                      nil
                    end
    end

    def amount=(amount)
      @amount = Mollie::Amount.new(amount)
    end

    def periods=(periods)
      @periods = Util.nested_openstruct(periods) if periods.is_a?(Hash)
    end

    def payments(options = {})
      Settlement::Payment.all(options.merge(settlement_id: id))
    end

    def refunds(options = {})
      Settlement::Refund.all(options.merge(settlement_id: id))
    end

    def chargebacks(options = {})
      Settlement::Chargeback.all(options.merge(settlement_id: id))
    end

    def invoice(options = {})
      return if invoice_id.nil?
      Invoice.get(invoice_id, options)
    end
  end
end

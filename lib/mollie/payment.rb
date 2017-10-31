module Mollie
  class Payment < Base
    STATUS_OPEN         = "open"
    STATUS_CANCELLED    = "cancelled"
    STATUS_EXPIRED      = "expired"
    STATUS_PAID         = "paid"
    STATUS_PAIDOUT      = "paidout"
    STATUS_FAILED       = "failed"
    STATUS_REFUNDED     = "refunded"
    STATUS_PENDING      = "pending"
    STATUS_CHARGED_BACK = "charged_back"

    RECURRINGTYPE_NONE      = nil
    RECURRINGTYPE_FIRST     = "first"
    RECURRINGTYPE_RECURRING = "recurring"

    attr_accessor :id,
                  :mode,
                  :created_datetime,
                  :status,
                  :paid_datetime,
                  :cancelled_datetime,
                  :expired_datetime,
                  :expiry_period,
                  :amount,
                  :amount_refunded,
                  :amount_remaining,
                  :description,
                  :method,
                  :metadata,
                  :locale,
                  :profile_id,
                  :settlement_id,
                  :customer_id,
                  :recurring_type,
                  :mandate_id,
                  :subscription_id,
                  :links,
                  :details

    def open?
      status == STATUS_OPEN
    end

    def cancelled?
      status == STATUS_CANCELLED
    end

    def expired?
      status == STATUS_EXPIRED
    end

    def paid?
      !!paid_datetime
    end

    def paidout?
      status == STATUS_PAIDOUT
    end

    def refunded?
      status == STATUS_REFUNDED
    end

    def failed?
      status == STATUS_FAILED
    end

    def pending?
      status == STATUS_PENDING
    end

    def charged_back?
      status == STATUS_CHARGED_BACK
    end

    def details=(details)
      @details = OpenStruct.new(details) if details.is_a?(Hash)
    end

    def metadata=(metadata)
      @metadata = OpenStruct.new(metadata) if metadata.is_a?(Hash)
    end

    def created_datetime=(created_datetime)
      @created_datetime = Time.parse(created_datetime.to_s) rescue nil
    end

    def paid_datetime=(paid_datetime)
      @paid_datetime = Time.parse(paid_datetime.to_s) rescue nil
    end

    def cancelled_datetime=(cancelled_datetime)
      @cancelled_datetime = Time.parse(cancelled_datetime.to_s) rescue nil
    end

    def expired_datetime=(expired_datetime)
      @expired_datetime = Time.parse(expired_datetime.to_s) rescue nil
    end

    def amount=(amount)
      @amount = BigDecimal.new(amount.to_s) if amount
    end

    def amount_remaining=(amount_remaining)
      @amount_remaining = BigDecimal.new(amount_remaining.to_s) if amount_remaining
    end

    def amount_refunded=(amount_refunded)
      @amount_refunded = BigDecimal.new(amount_refunded.to_s) if amount_refunded
    end

    def payment_url
      links && links['payment_url']
    end

    def webhook_url
      links && links['webhook_url']
    end

    def redirect_url
      links && links['redirect_url']
    end

    def refunds_url
      links && links['refunds']
    end

    def settlement
      links && links['settlement']
    end

    def refunds
      Relation.new(self, Payment::Refund)
    end

    def chargebacks
      Relation.new(self, Payment::Chargeback)
    end
  end
end

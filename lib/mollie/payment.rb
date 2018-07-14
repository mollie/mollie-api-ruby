module Mollie
  class Payment < Base
    STATUS_OPEN      = "open"
    STATUS_CANCELED  = "canceled"
    STATUS_EXPIRED   = "expired"
    STATUS_PAID      = "paid"
    STATUS_FAILED    = "failed"
    STATUS_PENDING   = "pending"

    RECURRINGTYPE_NONE      = nil
    RECURRINGTYPE_FIRST     = "first"
    RECURRINGTYPE_RECURRING = "recurring"

    attr_accessor :id,
                  :mode,
                  :created_at,
                  :status,
                  :paid_at,
                  :is_cancelable,
                  :canceled_at,
                  :expired_at,
                  :expires_at,
                  :failed_at,
                  :amount,
                  :amount_refunded,
                  :amount_remaining,
                  :description,
                  :method,
                  :metadata,
                  :locale,
                  :country_code,
                  :profile_id,
                  :settlement_amount,
                  :settlement_id,
                  :customer_id,
                  :sequence_type,
                  :mandate_id,
                  :subscription_id,
                  :application_fee,
                  :_links,
                  :details,
                  :redirect_url,
                  :webhook_url

    alias_method :links, :_links

    def open?
      status == STATUS_OPEN
    end

    def canceled?
      status == STATUS_CANCELED
    end

    def expired?
      status == STATUS_EXPIRED
    end

    def paid?
      status == STATUS_PAID
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

    def application_fee=(application_fee)
      amount      = Amount.new(application_fee["amount"])
      description = application_fee["description"]

      @application_fee = OpenStruct.new(
        amount: amount,
        description: description
      )
    end

    def details=(details)
      @details = OpenStruct.new(details) if details.is_a?(Hash)
    end

    def metadata=(metadata)
      @metadata = OpenStruct.new(metadata) if metadata.is_a?(Hash)
    end

    def created_at=(created_at)
      @created_at = Time.parse(created_at.to_s) rescue nil
    end

    def paid_at=(paid_at)
      @paid_at = Time.parse(paid_at.to_s) rescue nil
    end

    def canceled_at=(canceled_at)
      @canceled_at = Time.parse(canceled_at.to_s) rescue nil
    end

    def expired_at=(expired_at)
      @expired_at = Time.parse(expired_at.to_s) rescue nil
    end

    def expires_at=(expires_at)
      @expires_at = Time.parse(expires_at.to_s) rescue nil
    end

    def failed_at=(failed_at)
      @failed_at = Time.parse(failed_at)
    end

    def amount=(amount)
      @amount = Mollie::Amount.new(amount)
    end

    def settlement_amount=(settlement_amount)
      @settlement_amount = Mollie::Amount.new(settlement_amount)
    end

    def amount_remaining=(amount_remaining)
      @amount_remaining = Mollie::Amount.new(amount_remaining)
    end

    def amount_refunded=(amount_refunded)
      @amount_refunded = Mollie::Amount.new(amount_refunded)
    end

    def checkout_url
      Util.extract_url(links, 'checkout')
    end

    def refund!(options = {})
      options[:payment_id] = id
      # refund full amount by default
      options[:amount] ||= amount.to_h
      Payment::Refund.create(options)
    end

    def refunds
      Relation.new(self, Payment::Refund)
    end

    def chargebacks
      Relation.new(self, Payment::Chargeback)
    end

    def customer(options = {})
      return if customer_id.nil?
      Customer.get(customer_id, options)
    end

    def mandate(options = {})
      return if mandate_id.nil?
      Customer::Mandate.get(mandate_id, options)
    end

    def settlement(options = {})
      return if settlement_id.nil?
      Settlement.get(settlement_id, options)
    end

    def subscription(options = {})
      return if customer_id.nil?
      return if subscription_id.nil?
      options = options.merge(customer_id: customer_id)
      Customer::Subscription.get(subscription_id, options)
    end
  end
end

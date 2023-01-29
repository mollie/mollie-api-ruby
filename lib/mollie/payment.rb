module Mollie
  class Payment < Base
    STATUS_OPEN       = 'open'.freeze
    STATUS_CANCELED   = 'canceled'.freeze
    STATUS_PENDING    = 'pending'.freeze
    STATUS_EXPIRED    = 'expired'.freeze
    STATUS_FAILED     = 'failed'.freeze
    STATUS_PAID       = 'paid'.freeze
    STATUS_AUTHORIZED = 'authorized'.freeze

    RECURRINGTYPE_NONE      = nil
    RECURRINGTYPE_FIRST     = 'first'.freeze
    RECURRINGTYPE_RECURRING = 'recurring'.freeze

    attr_accessor :id,
                  :mode,
                  :created_at,
                  :status,
                  :authorized_at,
                  :paid_at,
                  :is_cancelable,
                  :canceled_at,
                  :expired_at,
                  :expires_at,
                  :failed_at,
                  :amount,
                  :amount_captured,
                  :amount_charged_back,
                  :amount_refunded,
                  :amount_remaining,
                  :description,
                  :method,
                  :metadata,
                  :locale,
                  :restrict_payment_methods_to_country,
                  :country_code,
                  :profile_id,
                  :settlement_amount,
                  :settlement_id,
                  :customer_id,
                  :sequence_type,
                  :mandate_id,
                  :subscription_id,
                  :order_id,
                  :application_fee,
                  :_links,
                  :details,
                  :redirect_url,
                  :cancel_url,
                  :webhook_url

    alias links _links

    def open?
      status == STATUS_OPEN
    end

    def canceled?
      status == STATUS_CANCELED
    end

    def pending?
      status == STATUS_PENDING
    end

    def expired?
      status == STATUS_EXPIRED
    end

    def failed?
      status == STATUS_FAILED
    end

    def paid?
      status == STATUS_PAID
    end

    def authorized?
      status == STATUS_AUTHORIZED
    end

    def refunded?
      if amount_refunded
        amount_refunded.value > 0
      else
        false
      end
    end

    def cancelable?
      is_cancelable
    end

    def application_fee=(application_fee)
      amount      = Amount.new(application_fee['amount'])
      description = application_fee['description']

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
      @created_at = begin
                      Time.parse(created_at.to_s)
                    rescue StandardError
                      nil
                    end
    end

    def authorized_at=(authorized_at)
      @authorized_at = begin
                         Time.parse(authorized_at.to_s)
                       rescue StandardError
                         nil
                       end
    end

    def paid_at=(paid_at)
      @paid_at = begin
                   Time.parse(paid_at.to_s)
                 rescue StandardError
                   nil
                 end
    end

    def canceled_at=(canceled_at)
      @canceled_at = begin
                       Time.parse(canceled_at.to_s)
                     rescue StandardError
                       nil
                     end
    end

    def expired_at=(expired_at)
      @expired_at = begin
                      Time.parse(expired_at.to_s)
                    rescue StandardError
                      nil
                    end
    end

    def expires_at=(expires_at)
      @expires_at = begin
                      Time.parse(expires_at.to_s)
                    rescue StandardError
                      nil
                    end
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

    def amount_captured=(amount_captured)
      @amount_captured = Mollie::Amount.new(amount_captured)
    end

    def amount_charged_back=(amount_charged_back)
      @amount_charged_back = Mollie::Amount.new(amount_charged_back)
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

    def refunds(options = {})
      Payment::Refund.all(options.merge(payment_id: id))
    end

    def chargebacks(options = {})
      Payment::Chargeback.all(options.merge(payment_id: id))
    end

    def captures(options = {})
      Payment::Capture.all(options.merge(payment_id: id))
    end

    def customer(options = {})
      return if customer_id.nil?
      Customer.get(customer_id, options)
    end

    def mandate(options = {})
      return if customer_id.nil?
      return if mandate_id.nil?
      options = options.merge(customer_id: customer_id)
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

    def order(options = {})
      return if order_id.nil?
      Order.get(order_id, options)
    end
  end
end

module Mollie
  class Order < Base
    STATUS_PENDING    = 'pending'.freeze
    STATUS_AUTHORIZED = 'authorized'.freeze
    STATUS_PAID       = 'paid'.freeze
    STATUS_SHIPPING   = 'shipping'.freeze
    STATUS_EXPIRED    = 'expired'.freeze
    STATUS_CANCELED   = 'canceled'.freeze
    STATUS_COMPLETED  = 'completed'.freeze

    attr_accessor :id,
                  :profile_id,
                  :method,
                  :mode,
                  :amount,
                  :amount_captured,
                  :amount_refunded,
                  :status,
                  :is_cancelable,
                  :billing_address,
                  :shopper_country_must_match_billing_country,
                  :consumer_date_of_birth,
                  :order_number,
                  :shipping_address,
                  :locale,
                  :metadata,
                  :redirect_url,
                  :cancel_url,
                  :webhook_url,
                  :created_at,
                  :expires_at,
                  :expired_at,
                  :paid_at,
                  :authorized_at,
                  :canceled_at,
                  :completed_at,
                  :lines,
                  :_links

    alias links _links

    def pending?
      status == STATUS_PENDING
    end

    def authorized?
      status == STATUS_AUTHORIZED
    end

    def paid?
      status == STATUS_PAID
    end

    def shipping?
      status == STATUS_SHIPPING
    end

    def expired?
      status == STATUS_EXPIRED
    end

    def canceled?
      status == STATUS_CANCELED
    end

    def completed?
      status == STATUS_COMPLETED
    end

    def cancelable?
      is_cancelable
    end

    def checkout_url
      Util.extract_url(links, 'checkout')
    end

    def lines=(lines)
      @lines = lines.map { |line| Order::Line.new(line) }
    end

    def amount=(amount)
      @amount = Mollie::Amount.new(amount)
    end

    def amount_captured=(amount)
      @amount_captured = Mollie::Amount.new(amount)
    end

    def amount_refunded=(amount)
      @amount_refunded = Mollie::Amount.new(amount)
    end

    def billing_address=(address)
      @billing_address = OpenStruct.new(address) if address.is_a?(Hash)
    end

    def shipping_address=(address)
      @shipping_address = OpenStruct.new(address) if address.is_a?(Hash)
    end

    def metadata=(metadata)
      @metadata = OpenStruct.new(metadata) if metadata.is_a?(Hash)
    end

    def created_at=(created_at)
      @created_at = Time.parse(created_at.to_s)
    end

    def expires_at=(expires_at)
      @expires_at = Time.parse(expires_at.to_s)
    end

    def expired_at=(expired_at)
      @expired_at = Time.parse(expired_at.to_s)
    end

    def paid_at=(paid_at)
      @paid_at = Time.parse(paid_at.to_s)
    end

    def authorized_at=(authorized_at)
      @authorized_at = Time.parse(authorized_at.to_s)
    end

    def canceled_at=(canceled_at)
      @canceled_at = Time.parse(canceled_at.to_s)
    end

    def completed_at=(completed_at)
      @completed_at = Time.parse(completed_at.to_s)
    end

    def payments
      resources = (attributes['_embedded']['payments'] if attributes['_embedded'])

      if resources.nil?
        List.new({}, Order::Payment)
      else
        List.new({ '_embedded' => { 'payments' => resources } }, Order::Payment)
      end
    end

    def refunds(options = {})
      resources = (attributes['_embedded']['refunds'] if attributes['_embedded'])

      if resources.nil?
        # To avoid breaking changes, fallback to /v2/order/*orderId*/refunds
        # if the order was retrieved without embedded refunds.
        Order::Refund.all(options.merge(order_id: id))
      else
        List.new({ '_embedded' => { 'refunds' => resources } }, Order::Refund)
      end
    end

    def shipments
      resources = (attributes['_embedded']['shipments'] if attributes['_embedded'])

      if resources.nil?
        List.new({}, Order::Shipment)
      else
        List.new({ '_embedded' => { 'shipments' => resources } }, Order::Shipment)
      end
    end

    def refund!(options = {})
      options[:order_id] = id
      options[:lines] ||= []
      Order::Refund.create(options)
    end
  end
end

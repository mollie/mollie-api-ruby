module Mollie
  class Customer
    class Subscription < Base
      STATUS_ACTIVE    = "active"
      STATUS_PENDING   = "pending" # Waiting for a valid mandate.
      STATUS_CANCELLED = "cancelled"
      STATUS_SUSPENDED = "suspended" # Active, but mandate became invalid.
      STATUS_COMPLETED = "completed"

      attr_accessor :resource,
                    :id,
                    :customer_id,
                    :mode,
                    :created_at,
                    :status,
                    :amount,
                    :times,
                    :interval,
                    :description,
                    :method,
                    :cancelled_at,
                    :webhook_url

      def active?
        status == STATUS_ACTIVE
      end

      def pending?
        status == STATUS_PENDING
      end

      def suspended?
        status == STATUS_SUSPENDED
      end

      def cancelled?
        status == STATUS_CANCELLED
      end

      def completed?
        status == STATUS_COMPLETED
      end

      def created_at=(created_at)
        @created_at = Time.parse(created_at.to_s) rescue nil
      end

      def cancelled_at=(cancelled_at)
        @cancelled_at = Time.parse(cancelled_at.to_s) rescue nil
      end

      def amount=(amount)
        if amount
          @amount   = BigDecimal.new(amount['value'].to_s)
          @currency = amount['currency']
        end
      end

      def times=(times)
        @times = times.to_i
      end
    end
  end
end

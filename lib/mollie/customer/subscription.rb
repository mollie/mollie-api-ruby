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
                    :created_datetime,
                    :status,
                    :amount,
                    :times,
                    :interval,
                    :description,
                    :method,
                    :cancelled_datetime,
                    :links

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

      def created_datetime=(created_datetime)
        @created_datetime = Time.parse(created_datetime.to_s) rescue nil
      end

      def cancelled_datetime=(cancelled_datetime)
        @cancelled_datetime = Time.parse(cancelled_datetime.to_s) rescue nil
      end

      def amount=(amount)
        @amount = BigDecimal.new(amount.to_s)
      end

      def times=(times)
        @times = times.to_i
      end

      def webhook_url
        links && links['webhook_url']
      end
    end
  end
end

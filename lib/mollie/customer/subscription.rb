module Mollie
  class Customer
    class Subscription < Base
      STATUS_ACTIVE    = "active"
      STATUS_PENDING   = "pending" # Waiting for a valid mandate.
      STATUS_CANCELED  = "canceled"
      STATUS_SUSPENDED = "suspended" # Active, but mandate became invalid.
      STATUS_COMPLETED = "completed"

      attr_accessor :id,
                    :customer_id,
                    :mode,
                    :created_at,
                    :status,
                    :amount,
                    :times,
                    :interval,
                    :description,
                    :method,
                    :canceled_at,
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

      def canceled?
        status == STATUS_CANCELED
      end

      def completed?
        status == STATUS_COMPLETED
      end

      def created_at=(created_at)
        @created_at = Time.parse(created_at.to_s) rescue nil
      end

      def canceled_at=(canceled_at)
        @canceled_at = Time.parse(canceled_at.to_s) rescue nil
      end

      def amount=(amount)
        @amount = Mollie::Amount.new(amount)
      end

      def times=(times)
        @times = times.to_i
      end
    end
  end
end

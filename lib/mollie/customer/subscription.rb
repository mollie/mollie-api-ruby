module Mollie
  class Customer
    class Subscription < Base
      STATUS_ACTIVE    = 'active'.freeze
      STATUS_PENDING   = 'pending'.freeze # Waiting for a valid mandate.
      STATUS_CANCELED  = 'canceled'.freeze
      STATUS_SUSPENDED = 'suspended'.freeze # Active, but mandate became invalid.
      STATUS_COMPLETED = 'completed'.freeze

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
                    :mandate_id,
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
        @created_at = begin
                        Time.parse(created_at.to_s)
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

      def amount=(amount)
        @amount = Mollie::Amount.new(amount)
      end

      def times=(times)
        @times = times.to_i
      end

      def customer(options = {})
        Customer.get(customer_id, options)
      end
    end
  end
end

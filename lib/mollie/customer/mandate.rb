module Mollie
  class Customer
    class Mandate < Base
      STATUS_VALID   = 'valid'.freeze
      STATUS_INVALID = 'invalid'.freeze
      STATUS_PENDING = 'pending'.freeze

      attr_accessor :id,
                    :status,
                    :method,
                    :details,
                    :mandate_reference,
                    :signature_date,
                    :created_at,
                    :_links

      alias links _links

      def details=(details)
        @details = OpenStruct.new(details) if details.is_a?(Hash)
      end

      def created_at=(created_at)
        @created_at = begin
                        Time.parse(created_at.to_s)
                      rescue StandardError
                        nil
                      end
      end

      def valid?
        status == STATUS_VALID
      end

      def pending?
        status == STATUS_PENDING
      end

      def invalid?
        status == STATUS_INVALID
      end

      def customer(options = {})
        customer_id = Util.extract_id(links, 'customer')
        Customer.get(customer_id, options)
      end
    end
  end
end

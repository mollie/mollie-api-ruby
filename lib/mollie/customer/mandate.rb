module Mollie
  class Customer
    class Mandate < Base
      STATUS_VALID   = "valid"
      STATUS_INVALID = "invalid"
      STATUS_PENDING = "pending"

      attr_accessor :id,
                    :status,
                    :method,
                    :details,
                    :mandate_reference,
                    :signature_date,
                    :created_at,
                    :_links

      alias_method :links, :_links

      def details=(details)
        @details = OpenStruct.new(details) if details.is_a?(Hash)
      end

      def created_at=(created_at)
        @created_at = Time.parse(created_at.to_s) rescue nil
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
        customer_id = Util.extract_id(links, "customer")
        Customer.get(customer_id, options)
      end
    end
  end
end

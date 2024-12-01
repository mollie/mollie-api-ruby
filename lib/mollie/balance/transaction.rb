module Mollie
  class Balance
    class Transaction < Base
      attr_accessor :id,
                    :type,
                    :_links

      attr_reader :result_amount,
                  :initial_amount,
                  :deductions,
                  :context,
                  :created_at

      alias links _links

      def self.embedded_resource_name
        "balance_transactions"
      end

      def result_amount=(amount)
        @result_amount = Mollie::Amount.new(amount)
      end

      def initial_amount=(amount)
       @initial_amount = Mollie::Amount.new(amount)
      end

      def deductions=(amount)
       @deductions = Mollie::Amount.new(amount)
      end

      def context=(context)
        @context = OpenStruct.new(context) if context.is_a?(Hash)
      end

      def created_at=(created_at)
        @created_at = Time.parse(created_at.to_s)
      end
    end
  end
end

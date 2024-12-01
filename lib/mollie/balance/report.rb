module Mollie
  class Balance
    class Report < Base
      attr_accessor :balance_id,
                    :time_zone,
                    :grouping,
                    :totals,
                    :_links

      attr_reader :from,
                  :until

      alias links _links

      def from=(from)
        @from = Date.parse(from)
      end

      def until=(until_date)
        # `until` is a reserved keyword
        @until = Date.parse(until_date)
      end
    end
  end
end

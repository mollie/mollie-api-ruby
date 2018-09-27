module Mollie
  class Order
    class Shipment < Base
      attr_accessor :id,
                    :order_id,
                    :created_at,
                    :tracking,
                    :lines,
                    :_links

      alias links _links

      def tracking
        @tracking || OpenStruct.new
      end

      def tracking=(tracking)
        @tracking = OpenStruct.new(tracking) if tracking.is_a?(Hash)
      end

      def lines=(lines)
        @lines = lines.map { |line| Order::Line.new(line) }
      end

      def created_at=(created_at)
        @created_at = Time.parse(created_at.to_s)
      end

      def order(options = {})
        Order.get(order_id, options)
      end
    end
  end
end

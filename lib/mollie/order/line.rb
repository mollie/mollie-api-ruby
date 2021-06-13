module Mollie
  class Order
    class Line < Base
      attr_accessor :id,
                    :order_id,
                    :type,
                    :name,
                    :status,
                    :metadata,
                    :is_cancelable,
                    :quantity,
                    :quantity_shipped,
                    :amount_shipped,
                    :quantity_refunded,
                    :amount_refunded,
                    :quantity_canceled,
                    :amount_canceled,
                    :shippable_quantity,
                    :refundable_quantity,
                    :cancelable_quantity,
                    :unit_price,
                    :discount_amount,
                    :total_amount,
                    :vat_rate,
                    :vat_amount,
                    :sku,
                    :created_at,
                    :_links

      alias links _links

      def self.update(id, data = {})
        request('PATCH', id, data) { |response| Order.new(response) }
      end

      def cancelable?
        is_cancelable == true
      end

      def discounted?
        !@discount_amount.nil?
      end

      def shippable?
        shippable_quantity.to_i > 0
      end

      def refundable?
        refundable_quantity.to_i > 0
      end

      def product_url
        Util.extract_url(links, 'product_url')
      end

      def image_url
        Util.extract_url(links, 'image_url')
      end

      def metadata=(metadata)
        @metadata = OpenStruct.new(metadata) if metadata.is_a?(Hash)
      end

      def amount_shipped=(amount)
        @amount_shipped = Mollie::Amount.new(amount)
      end

      def amount_refunded=(amount)
        @amount_refunded = Mollie::Amount.new(amount)
      end

      def amount_canceled=(amount)
        @amount_canceled = Mollie::Amount.new(amount)
      end

      def unit_price=(amount)
        @unit_price = Mollie::Amount.new(amount)
      end

      def discount_amount=(amount)
        @discount_amount = Mollie::Amount.new(amount)
      end

      def total_amount=(amount)
        @total_amount = Mollie::Amount.new(amount)
      end

      def vat_amount=(amount)
        @vat_amount = Mollie::Amount.new(amount)
      end

      def created_at=(created_at)
        @created_at = Time.parse(created_at.to_s)
      end

      def cancel(options = {})
        qty = options.delete(:quantity) || quantity
        options[:lines] = [{ id: id, quantity: qty }]
        options[:order_id] = order_id
        Mollie::Order::Line.delete(nil, options)
      end
    end
  end
end

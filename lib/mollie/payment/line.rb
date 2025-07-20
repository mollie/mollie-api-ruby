module Mollie
  class Payment
    class Line < Base
      attr_accessor :type,
                    :description,
                    :quantity,
                    :quantity_unit,
                    :vat_rate,
                    :sku,
                    :categories,
                    :image_url,
                    :product_url

      attr_reader :unit_price,
                  :discount_amount,
                  :recurring,
                  :total_amount,
                  :vat_amount

      def discounted?
        !@discount_amount.nil?
      end

      def unit_price=(amount)
        @unit_price = Mollie::Amount.new(amount)
      end

      def discount_amount=(amount)
        @discount_amount = Mollie::Amount.new(amount)
      end

      def recurring=(object)
        return if object.nil?

        @recurring = OpenStruct.new(object).tap do |r|
          r.amount = Mollie::Amount.new(r.amount) if r.amount
          r.start_date = Date.parse(r.start_date) if r.start_date
        end
      end

      def total_amount=(amount)
        @total_amount = Mollie::Amount.new(amount)
      end

      def vat_amount=(amount)
        @vat_amount = Mollie::Amount.new(amount)
      end
    end
  end
end

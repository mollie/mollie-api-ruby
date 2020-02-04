module Mollie
  class Payment
    class Capture < Base
      attr_accessor :id,
                    :mode,
                    :amount,
                    :settlement_amount,
                    :payment_id,
                    :shipment_id,
                    :settlement_id,
                    :created_at,
                    :_links

      alias links _links

      def amount=(amount)
        @amount = Mollie::Amount.new(amount)
      end

      def settlement_amount=(amount)
        @settlement_amount = Mollie::Amount.new(amount)
      end

      def created_at=(created_at)
        @created_at = Time.parse(created_at.to_s)
      end

      def payment(options = {})
        Payment.get(payment_id, options)
      end

      def shipment(options = {})
        resource_url = Util.extract_url(links, 'shipment')
        response = Client.instance.perform_http_call('GET', resource_url, nil, {}, options)
        Order::Shipment.new(response)
      end

      def settlement(options = {})
        return if settlement_id.nil?
        Settlement.get(settlement_id, options)
      end
    end
  end
end

require 'helper'

module Mollie
  class Order
    class LineTest < Test::Unit::TestCase
      GET_ORDER   = read_fixture('orders/get.json')
      CANCEL_LINE = read_fixture('orders/cancel_line.json')
      CANCEL_QTY  = read_fixture('orders/cancel_line_qty.json')

      def test_discounted
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
          .to_return(status: 200, body: GET_ORDER, headers: {})

        order = Order.get('ord_kEn1PlbGa')
        assert order.lines[0].discounted?
        assert order.lines[1].discounted? == false
      end

      def test_cancel_order_line
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
          .to_return(status: 200, body: GET_ORDER, headers: {})

        stub_request(:delete, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/lines')
          .with(body: JSON.parse(CANCEL_LINE).to_json)
          .to_return(status: 204, body: GET_ORDER, headers: {})

        order = Order.get('ord_kEn1PlbGa')
        assert_nil order.lines.first.cancel
      end

      def test_cancel_order_line_with_quantity
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
          .to_return(status: 200, body: GET_ORDER, headers: {})

        stub_request(:delete, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/lines')
          .with(body: JSON.parse(CANCEL_QTY).to_json)
          .to_return(status: 204, body: GET_ORDER, headers: {})

        order = Order.get('ord_kEn1PlbGa')
        assert_nil order.lines.first.cancel(quantity: 1)
      end

    end
  end
end

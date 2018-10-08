require 'helper'

module Mollie
  class Order
    class ShipmentTest < Test::Unit::TestCase
      GET_ORDER       = read_fixture('orders/get.json')
      GET_SHIPMENT    = read_fixture('shipments/get.json')
      CREATE_SHIPMENT = read_fixture('shipments/create.json')
      LIST_SHIPMENTS  = read_fixture('shipments/list.json')
      UPDATE_SHIPMENT = read_fixture('shipments/update.json')

      def test_get_shipment
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .to_return(status: 200, body: GET_SHIPMENT, headers: {})

        shipment = Order::Shipment.get('shp_3wmsgCJN4U', order_id: 'ord_kEn1PlbGa')
        assert_equal 'shp_3wmsgCJN4U', shipment.id
        assert_equal 'ord_kEn1PlbGa', shipment.order_id
        assert_equal Time.parse('2018-08-09T14:33:54+00:00'), shipment.created_at
      end

      def test_tracking_details
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .to_return(status: 200, body: GET_SHIPMENT, headers: {})

        shipment = Order::Shipment.get('shp_3wmsgCJN4U', order_id: 'ord_kEn1PlbGa')
        assert_equal 'shp_3wmsgCJN4U', shipment.id
        assert_equal 'PostNL', shipment.tracking.carrier
        assert_equal '3SKABA000000000', shipment.tracking.code
        assert_equal 'http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C', shipment.tracking.url
      end

      def test_nil_tracking_details
        body = %({ "resource": "shipment", "id": "shp_3wmsgCJN4U" })
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .to_return(status: 200, body: body, headers: {})

        shipment = Order::Shipment.get('shp_3wmsgCJN4U', order_id: 'ord_kEn1PlbGa')
        assert_equal 'shp_3wmsgCJN4U', shipment.id
        assert_nil shipment.tracking.carrier
      end

      def test_order_lines
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .to_return(status: 200, body: GET_SHIPMENT, headers: {})

        shipment = Order::Shipment.get('shp_3wmsgCJN4U', order_id: 'ord_kEn1PlbGa')
        assert shipment.lines.size == 2

        line = shipment.lines.first
        assert_equal 'odl_dgtxyl', line.id
        assert_equal 'ord_kEn1PlbGa', line.order_id
        assert_equal 'LEGO 42083 Bugatti Chiron', line.name
        assert_equal 'https://shop.lego.com/nl-NL/Bugatti-Chiron-42083', line.product_url
        assert_equal 'https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$', line.image_url
        assert_equal '5702016116977', line.sku
        assert_equal 'physical', line.type
        assert_equal 'shipping', line.status
        assert_equal true, line.is_cancelable
        assert_equal true, line.cancelable?
        assert_equal 2, line.quantity
        assert_equal BigDecimal('399.00'), line.unit_price.value
        assert_equal 'EUR', line.unit_price.currency
        assert_equal '21.00', line.vat_rate
        assert_equal BigDecimal('121.14'), line.vat_amount.value
        assert_equal 'EUR', line.vat_amount.currency
        assert_equal BigDecimal('100.00'), line.discount_amount.value
        assert_equal 'EUR', line.discount_amount.currency
        assert_equal BigDecimal('698.00'), line.total_amount.value
        assert_equal 'EUR', line.total_amount.currency
        assert_equal Time.parse('2018-09-23T17:23:13+00:00'), line.created_at
      end

      def test_create_shipment
        stub_request(:post, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments')
          .with(body: CREATE_SHIPMENT.delete("\n "))
          .to_return(status: 201, body: GET_SHIPMENT, headers: {})

        shipment = Order::Shipment.create(
          order_id: 'ord_kEn1PlbGa',
          lines: [
            {
              id: 'odl_dgtxyl',
              quantity: 1
            },
            {
              id: 'odl_jp31jz'
            }
          ],
          tracking: {
            carrier: 'PostNL',
            code: '3SKABA000000000',
            url: 'http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C'
          }
        )

        assert_kind_of Order::Shipment, shipment
        assert_equal 'shp_3wmsgCJN4U', shipment.id
      end

      def test_list_shipments
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments')
          .to_return(status: 200, body: LIST_SHIPMENTS, headers: {})

        shipments = Order::Shipment.all(order_id: 'ord_kEn1PlbGa')
        assert_equal 1, shipments.size
        assert_equal 'shp_3wmsgCJN4U', shipments.first.id
        assert_equal 'ord_kEn1PlbGa', shipments.first.order_id
      end

      def test_update_shipment
        stub_request(:patch, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .with(body: UPDATE_SHIPMENT.delete("\n "))
          .to_return(status: 200, body: GET_SHIPMENT, headers: {})

        shipment = Order::Shipment.update(
          'shp_3wmsgCJN4U',
          order_id: 'ord_kEn1PlbGa',
          tracking: {
            carrier: 'PostNL',
            code: '3SKABA000000000',
            url: 'http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C'
          }
        )

        assert_kind_of Order::Shipment, shipment
        assert_equal 'shp_3wmsgCJN4U', shipment.id
      end

      def test_get_order
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .to_return(status: 200, body: GET_SHIPMENT, headers: {})

        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
          .to_return(status: 200, body: GET_ORDER, headers: {})

        shipment = Order::Shipment.get('shp_3wmsgCJN4U', order_id: 'ord_kEn1PlbGa')
        order = shipment.order
        assert_equal 'ord_kEn1PlbGa', order.id
      end
    end
  end
end

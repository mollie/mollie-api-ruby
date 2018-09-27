require 'helper'

module Mollie
  class Order
    class ShipmentTest < Test::Unit::TestCase

      ORDER_STUB = %(
        {
            "resource": "order",
            "id": "ord_kEn1PlbGa"
        }
      )

      SHIPMENT_STUB = %(
        {
            "resource": "shipment",
            "id": "shp_3wmsgCJN4U",
            "orderId": "ord_kEn1PlbGa",
            "createdAt": "2018-08-09T14:33:54+00:00",
            "tracking": {
                "carrier": "PostNL",
                "code": "3SKABA000000000",
                "url": "http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C"
            },
            "lines": [
                {
                    "resource": "orderline",
                    "id": "odl_dgtxyl",
                    "orderId": "ord_pbjz8x",
                    "name": "LEGO 42083 Bugatti Chiron",
                    "productUrl": "https://shop.lego.com/nl-NL/Bugatti-Chiron-42083",
                    "imageUrl": "https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$",
                    "sku": "5702016116977",
                    "type": "physical",
                    "status": "shipping",
                    "quantity": 2,
                    "unitPrice": {
                        "value": "399.00",
                        "currency": "EUR"
                    },
                    "vatRate": "21.00",
                    "vatAmount": {
                        "value": "121.14",
                        "currency": "EUR"
                    },
                    "discountAmount": {
                        "value": "100.00",
                        "currency": "EUR"
                    },
                    "totalAmount": {
                        "value": "698.00",
                        "currency": "EUR"
                    },
                    "createdAt": "2018-08-02T09:29:56+00:00"
                },
                {
                    "resource": "orderline",
                    "id": "odl_jp31jz",
                    "orderId": "ord_pbjz8x",
                    "name": "LEGO 42056 Porsche 911 GT3 RS",
                    "productUrl": "https://shop.lego.com/nl-NL/Porsche-911-GT3-RS-42056",
                    "imageUrl": "https://sh-s7-live-s.legocdn.com/is/image/LEGO/42056?$PDPDefault$",
                    "sku": "5702015594028",
                    "type": "physical",
                    "status": "shipping",
                    "quantity": 1,
                    "unitPrice": {
                        "value": "329.99",
                        "currency": "EUR"
                    },
                    "vatRate": "21.00",
                    "vatAmount": {
                        "value": "57.27",
                        "currency": "EUR"
                    },
                    "totalAmount": {
                        "value": "329.99",
                        "currency": "EUR"
                    },
                    "createdAt": "2018-08-02T09:29:56+00:00"
                }
            ],
            "_links": {
                "self": {
                    "href": "https://api.mollie.com/v2/order/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U",
                    "type": "application/hal+json"
                },
                "order": {
                    "href": "https://api.mollie.com/v2/orders/ord_kEn1PlbGa",
                    "type": "application/hal+json"
                },
                "documentation": {
                    "href": "https://docs.mollie.com/reference/v2/shipments-api/get-shipment",
                    "type": "text/html"
                }
            }
        }
      )

      CREATE_SHIPMENT_STUB = %(
        {
            "lines": [
                {
                    "id": "odl_dgtxyl",
                    "quantity": 1
                },
                {
                    "id": "odl_jp31jz"
                }
            ],
            "tracking": {
                "carrier": "PostNL",
                "code": "3SKABA000000000",
                "url": "http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C"
            }
        }
      )

      LIST_SHIPMENTS_STUB = %(
        {
            "count": 1,
            "_embedded": {
                "shipments": [
                    {
                        "resource": "shipment",
                        "id": "shp_3wmsgCJN4U",
                        "orderId": "ord_kEn1PlbGa",
                        "createdAt": "2018-08-09T14:33:54+00:00",
                        "tracking": {
                            "carrier": "PostNL",
                            "code": "3SKABA000000000",
                            "url": "http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C"
                        },
                        "lines": [
                            {
                                "resource": "orderline",
                                "id": "odl_dgtxyl",
                                "orderId": "ord_pbjz8x",
                                "name": "LEGO 42083 Bugatti Chiron",
                                "productUrl": "https://shop.lego.com/nl-NL/Bugatti-Chiron-42083",
                                "imageUrl": "https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$",
                                "sku": "5702016116977",
                                "type": "physical",
                                "status": "shipping",
                                "quantity": 2,
                                "unitPrice": {
                                    "value": "399.00",
                                    "currency": "EUR"
                                },
                                "vatRate": "21.00",
                                "vatAmount": {
                                    "value": "121.14",
                                    "currency": "EUR"
                                },
                                "discountAmount": {
                                    "value": "100.00",
                                    "currency": "EUR"
                                },
                                "totalAmount": {
                                    "value": "698.00",
                                    "currency": "EUR"
                                },
                                "createdAt": "2018-08-02T09:29:56+00:00"
                            }
                        ],
                        "_links": {
                            "self": {
                                "href": "https://api.mollie.com/v2/order/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U",
                                "type": "application/hal+json"
                            },
                            "order": {
                                "href": "https://api.mollie.com/v2/orders/ord_kEn1PlbGa",
                                "type": "application/hal+json"
                            },
                            "documentation": {
                                "href": "https://docs.mollie.com/reference/v2/shipments-api/get-shipment",
                                "type": "text/html"
                            }
                        }
                    }
                ]
            },
            "_links": {
                "self": {
                    "href": "https://api.mollie.com/v2/order/ord_kEn1PlbGa/shipments",
                    "type": "application/hal+json"
                },
                "documentation": {
                    "href": "https://docs.mollie.com/reference/v2/shipments-api/list-shipments",
                    "type": "text/html"
                }
            }
        }
      )

      UPDATE_SHIPMENT_STUB = %(
        {
            "tracking": {
                "carrier": "PostNL",
                "code": "3SKABA000000000",
                "url": "http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C"
            }
        }
      )

      def test_get_shipment
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .to_return(status: 200, body: SHIPMENT_STUB, headers: {})

        shipment = Order::Shipment.get('shp_3wmsgCJN4U', order_id: 'ord_kEn1PlbGa')
        assert_equal 'shp_3wmsgCJN4U', shipment.id
        assert_equal 'ord_kEn1PlbGa', shipment.order_id
        assert_equal Time.parse('2018-08-09T14:33:54+00:00'), shipment.created_at
      end

      def test_tracking_details
        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .to_return(status: 200, body: SHIPMENT_STUB, headers: {})

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
          .to_return(status: 200, body: SHIPMENT_STUB, headers: {})

        shipment = Order::Shipment.get('shp_3wmsgCJN4U', order_id: 'ord_kEn1PlbGa')
        assert shipment.lines.size == 2

        line = shipment.lines.first
        assert_equal 'odl_dgtxyl', line.id
        assert_equal 'ord_pbjz8x', line.order_id
        assert_equal 'LEGO 42083 Bugatti Chiron', line.name
        assert_equal 'https://shop.lego.com/nl-NL/Bugatti-Chiron-42083', line.product_url
        assert_equal 'https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$', line.image_url
        assert_equal '5702016116977', line.sku
        assert_equal 'physical', line.type
        assert_equal 'shipping', line.status
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
        assert_equal Time.parse('2018-08-02T09:29:56+00:00'), line.created_at
      end

      def test_create_shipment
        stub_request(:post, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments')
          .with(body: CREATE_SHIPMENT_STUB.delete("\n "))
          .to_return(status: 201, body: SHIPMENT_STUB, headers: {})

        shipment = Order::Shipment.create(
          order_id: 'ord_kEn1PlbGa',
          lines: [
            {
              id: "odl_dgtxyl",
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
          .to_return(status: 200, body: LIST_SHIPMENTS_STUB, headers: {})

        shipments = Order::Shipment.all(order_id: 'ord_kEn1PlbGa')
        assert_equal 1, shipments.size
        assert_equal 'shp_3wmsgCJN4U', shipments.first.id
        assert_equal 'ord_kEn1PlbGa', shipments.first.order_id
      end

      def test_update_shipment
        stub_request(:patch, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/shipments/shp_3wmsgCJN4U')
          .with(body: UPDATE_SHIPMENT_STUB.delete("\n "))
          .to_return(status: 200, body: SHIPMENT_STUB, headers: {})

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
          .to_return(status: 200, body: SHIPMENT_STUB, headers: {})

        stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
          .to_return(status: 200, body: ORDER_STUB, headers: {})

        shipment = Order::Shipment.get('shp_3wmsgCJN4U', order_id: 'ord_kEn1PlbGa')
        order = shipment.order
        assert_equal 'ord_kEn1PlbGa', order.id
      end

    end
  end
end

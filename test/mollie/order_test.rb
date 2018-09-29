require 'helper'

module Mollie
  class OrderTest < Test::Unit::TestCase
    CREATE_ORDER = read_fixture('orders/create.json')
    GET_ORDER    = read_fixture('orders/get.json')
    UPDATE_ORDER = read_fixture('orders/update.json')
    LIST_ORDER   = read_fixture('orders/list.json')

    # Refunds
    CREATE_ORDER_REFUND = read_fixture('orders/create_refund.json')
    REFUND_ALL_LINES    = read_fixture('orders/refund_all.json')
    LIST_ORDER_REFUNDS  = read_fixture('orders/list_refunds.json')
    GET_ORDER_REFUND    = read_fixture('orders/refund.json')

    def test_status_pending
      assert Order.new(status: Order::STATUS_PENDING).pending?
      assert !Order.new(status: 'not-pending').pending?
    end

    def test_status_authorized
      assert Order.new(status: Order::STATUS_AUTHORIZED).authorized?
      assert !Order.new(status: 'not-authorized').authorized?
    end

    def test_status_paid
      assert Order.new(status: Order::STATUS_PAID).paid?
      assert !Order.new(status: 'not-paid').paid?
    end

    def test_status_shipping
      assert Order.new(status: Order::STATUS_SHIPPING).shipping?
      assert !Order.new(status: 'not-shipping').shipping?
    end

    def test_status_expired
      assert Order.new(status: Order::STATUS_EXPIRED).expired?
      assert !Order.new(status: 'not-expired').expired?
    end

    def test_status_canceled
      assert Order.new(status: Order::STATUS_CANCELED).canceled?
      assert !Order.new(status: 'not-canceled').canceled?
    end

    def test_status_completed
      assert Order.new(status: Order::STATUS_COMPLETED).completed?
      assert !Order.new(status: 'not-completed').completed?
    end

    def test_status_refunded
      assert Order.new(status: Order::STATUS_REFUNDED).refunded?
      assert !Order.new(status: 'not-refunded').refunded?
    end

    def test_get_order
      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      assert_equal 'ord_kEn1PlbGa', order.id
      assert_equal 'pfl_URR55HPMGx', order.profile_id
      assert_equal 'ideal', order.method
      assert_equal 'live', order.mode
      assert_equal BigDecimal('1027.99'), order.amount.value
      assert_equal 'EUR', order.amount.currency
      assert_equal BigDecimal('0'), order.amount_captured.value
      assert_equal 'EUR', order.amount_captured.currency
      assert_equal BigDecimal('0'), order.amount_refunded.value
      assert_equal 'EUR', order.amount_refunded.currency
      assert_equal 'created', order.status
      assert_equal true, order.is_cancelable
      assert_equal '18475', order.order_number
      assert_equal 'nl_NL', order.locale
      assert_equal '1337', order.metadata.order_id
      assert_equal 'Lego cars', order.metadata.description
      assert_equal 'https://redirect-url', order.redirect_url
      assert_equal 'https://webhook-url', order.webhook_url
      assert_equal Time.parse('2018-08-02T09:29:56+00:00'), order.created_at
      assert_equal Time.parse('2018-08-30T09:29:56+00:00'), order.expires_at
      assert_equal Time.parse('2018-08-30T09:29:56+00:02'), order.expired_at
      assert_equal Time.parse('2018-08-26T09:29:56+00:00'), order.paid_at
      assert_equal Time.parse('2018-08-25T09:29:56+00:00'), order.authorized_at
      assert_equal Time.parse('2018-08-27T09:29:56+00:00'), order.canceled_at
      assert_equal Time.parse('2018-08-28T09:29:56+00:00'), order.completed_at
    end

    def test_cancelable?
      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      assert_equal true, order.is_cancelable
      assert_equal true, order.cancelable?
    end

    def test_checkout_url
      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      assert_equal 'https://www.mollie.com/payscreen/order/checkout/kEn1PlbGa', order.checkout_url
    end

    def test_billing_address
      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      assert_equal 'Keizersgracht 313', order.billing_address.street_and_number
      assert_equal '1016 EE', order.billing_address.postal_code
      assert_equal 'Amsterdam', order.billing_address.city
      assert_equal 'nl', order.billing_address.country
      assert_equal 'Luke', order.billing_address.given_name
      assert_equal 'Skywalker', order.billing_address.family_name
      assert_equal 'luke@skywalker.com', order.billing_address.email
    end

    def test_shipping_address
      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      assert_equal 'Keizersgracht 313', order.shipping_address.street_and_number
      assert_equal '1016 EE', order.shipping_address.postal_code
      assert_equal 'Amsterdam', order.shipping_address.city
      assert_equal 'nl', order.shipping_address.country
      assert_equal 'Luke', order.shipping_address.given_name
      assert_equal 'Skywalker', order.shipping_address.family_name
      assert_equal 'luke@skywalker.com', order.shipping_address.email
    end

    def test_order_lines
      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      line = order.lines.first
      assert order.lines.size == 2

      assert_equal 'odl_dgtxyl', line.id
      assert_equal 'ord_kEn1PlbGa', line.order_id
      assert_equal 'LEGO 42083 Bugatti Chiron', line.name
      assert_equal 'https://shop.lego.com/nl-NL/Bugatti-Chiron-42083', line.product_url
      assert_equal 'https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$', line.image_url
      assert_equal '5702016116977', line.sku
      assert_equal 'physical', line.type
      assert_equal 'created', line.status
      assert_equal true, line.is_cancelable
      assert_equal true, line.cancelable?
      assert_equal 2, line.quantity
      assert_equal 0, line.quantity_shipped
      assert_equal 0, line.quantity_refunded
      assert_equal 0, line.quantity_canceled
      assert_equal '21.00', line.vat_rate

      assert_equal BigDecimal('0'), line.amount_shipped.value
      assert_equal 'EUR', line.amount_shipped.currency

      assert_equal BigDecimal('0'), line.amount_refunded.value
      assert_equal 'EUR', line.amount_refunded.currency

      assert_equal BigDecimal('0'), line.amount_canceled.value
      assert_equal 'EUR', line.amount_canceled.currency

      assert_equal BigDecimal('399.0'), line.unit_price.value
      assert_equal 'EUR', line.unit_price.currency

      assert_equal BigDecimal('100.0'), line.discount_amount.value
      assert_equal 'EUR', line.discount_amount.currency

      assert_equal BigDecimal('698.0'), line.total_amount.value
      assert_equal 'EUR', line.total_amount.currency

      assert_equal BigDecimal('121.14'), line.vat_amount.value
      assert_equal 'EUR', line.vat_amount.currency

      assert_equal Time.parse('2018-08-02T09:29:56+00:00'), line.created_at
    end

    def test_create_order
      minified_body = JSON.parse(CREATE_ORDER).to_json
      stub_request(:post, 'https://api.mollie.com/v2/orders')
        .with(body: minified_body)
        .to_return(status: 201, body: GET_ORDER, headers: {})

      order = Order.create(JSON.parse(CREATE_ORDER))

      assert_kind_of Order, order
      assert_equal 'ord_kEn1PlbGa', order.id
    end

    def test_update_order
      minified_body = JSON.parse(UPDATE_ORDER).to_json
      stub_request(:patch, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .with(body: minified_body)
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.update('ord_kEn1PlbGa', JSON.parse(UPDATE_ORDER))

      assert_kind_of Order, order
      assert_equal 'ord_kEn1PlbGa', order.id
    end

    def test_cancel_order
      stub_request(:delete, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.cancel('ord_kEn1PlbGa')
      assert_nil order
    end

    def test_cancel_order_instance
      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      stub_request(:delete, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      assert_nil order.cancel
    end

    def test_list_orders
      stub_request(:get, 'https://api.mollie.com/v2/orders')
        .to_return(status: 200, body: LIST_ORDER, headers: {})

      orders = Order.all
      assert_equal 3, orders.size
      assert_equal 'ord_one', orders[0].id
      assert_equal 'ord_two', orders[1].id
      assert_equal 'ord_three', orders[2].id
    end

    def test_create_order_refund
      request_body = JSON.parse(CREATE_ORDER_REFUND, symbolize_names: true)

      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      stub_request(:post, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/refunds')
        .with(body: request_body.to_json)
        .to_return(status: 201, body: GET_ORDER_REFUND, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      refund = order.refund!(request_body)

      assert_kind_of Order::Refund, refund
      assert_equal 're_4qqhO89gsT', refund.id
      assert_equal 'ord_kEn1PlbGa', refund.order_id
    end

    def test_refund_all_lines
      request_body = JSON.parse(REFUND_ALL_LINES, symbolize_names: true)

      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      stub_request(:post, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/refunds')
        .with(body: request_body.to_json)
        .to_return(status: 201, body: GET_ORDER_REFUND, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      refund = order.refund!

      assert_kind_of Order::Refund, refund
      assert_equal 're_4qqhO89gsT', refund.id
      assert_equal 'ord_kEn1PlbGa', refund.order_id
    end

    def test_list_order_refunds
      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: GET_ORDER, headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa/refunds')
        .to_return(status: 200, body: LIST_ORDER_REFUNDS, headers: {})

      order = Order.get('ord_kEn1PlbGa')
      refunds = order.refunds

      assert_equal 1, refunds.size
      assert_kind_of Order::Refund, refunds.first
      assert_equal 're_4qqhO89gsT', refunds.first.id
      assert_equal 'ord_kEn1PlbGa', refunds.first.order_id
    end
  end
end

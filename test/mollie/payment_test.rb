require 'helper'

module Mollie
  class PaymentTest < Test::Unit::TestCase
    GET_PAYMENT_WITH_EMBEDDED_RESOURCES = read_fixture('payments/get_embedded_resources.json')

    def test_setting_attributes
      attributes = {
        resource:   'payment',
        id:         'tr_7UhSN1zuXS',
        mode:       'test',
        created_at: '2018-03-20T09:13:37+00:00',
        amount: {
          'value'    => '10.00',
          'currency' => 'EUR'
        },
        description:  'My first payment',
        method:       'ideal',
        country_code: 'NL',
        metadata: {
          order_id: '12345'
        },
        details:       {
          consumer_name:    "Hr E G H K\u00fcppers en\/of MW M.J. K\u00fcppers-Veeneman",
          consumer_account: 'NL53INGB0618365937',
          consumer_bic:     'INGBNL2A'
        },
        status:        'paid',
        authorized_at: '2018-03-19T09:14:37+00:00',
        paid_at:       '2018-03-20T09:14:37+00:00',
        is_cancelable: false,
        expires_at:    '2018-03-20T09:28:37+00:00',
        locale:        'nl_NL',
        profile_id:    'pfl_QkEhN94Ba',
        sequence_type: 'oneoff',
        redirect_url:  'https://webshop.example.org/order/12345',
        cancel_url:    'https://webshop.example.org/payments/cancel',
        webhook_url:   'https://webshop.example.org/payments/webhook',
        _links:        {
          'self' => {
            'href' => 'https://api.mollie.com/v2/payments/tr_7UhSN1zuXS',
            'type' => 'application/json'
          },
          'checkout' => {
            'href' => 'https://www.mollie.com/payscreen/select-method/7UhSN1zuXS',
            'type' => 'text/html'
          },
          'settlement' => {
            'href' => 'https://webshop.example.org/payment/tr_WDqYK6vllg/settlement'
          },
          'refunds' => {
            'href' => 'https://webshop.example.org/payment/tr_WDqYK6vllg/refunds',
            'type' => 'text/html'
          }
        }
      }

      payment = Payment.new(attributes)

      assert_equal 'tr_7UhSN1zuXS', payment.id
      assert_equal 'test', payment.mode
      assert_equal Time.parse('2018-03-20T09:13:37+00:00'), payment.created_at
      assert_equal 'paid', payment.status
      assert_equal true, payment.paid?
      assert_equal Time.parse('2018-03-19T09:14:37+00:00'), payment.authorized_at
      assert_equal Time.parse('2018-03-20T09:14:37+00:00'), payment.paid_at
      assert_equal 10.00, payment.amount.value
      assert_equal 'EUR', payment.amount.currency
      assert_equal 'My first payment', payment.description
      assert_equal 'ideal', payment.method
      assert_equal '12345', payment.metadata.order_id
      assert_equal "Hr E G H K\u00fcppers en\/of MW M.J. K\u00fcppers-Veeneman", payment.details.consumer_name
      assert_equal 'NL53INGB0618365937', payment.details.consumer_account
      assert_equal 'INGBNL2A', payment.details.consumer_bic
      assert_equal 'nl_NL', payment.locale
      assert_equal 'NL', payment.country_code
      assert_equal 'pfl_QkEhN94Ba', payment.profile_id
      assert_equal 'https://webshop.example.org/order/12345', payment.redirect_url
      assert_equal 'https://webshop.example.org/payments/cancel', payment.cancel_url
      assert_equal 'https://webshop.example.org/payments/webhook', payment.webhook_url
      assert_equal 'https://www.mollie.com/payscreen/select-method/7UhSN1zuXS', payment.checkout_url
      assert_equal false, payment.cancelable?
    end

    def test_status_open
      assert Payment.new(status: Payment::STATUS_OPEN).open?
      assert !Payment.new(status: 'not-open').open?
    end

    def test_status_canceled
      assert Payment.new(status: Payment::STATUS_CANCELED).canceled?
      assert !Payment.new(status: 'not-canceled').canceled?
    end

    def test_status_pending
      assert Payment.new(status: Payment::STATUS_PENDING).pending?
      assert !Payment.new(status: 'not-pending').pending?
    end

    def test_status_expired
      assert Payment.new(status: Payment::STATUS_EXPIRED).expired?
      assert !Payment.new(status: 'not-expired').expired?
    end

    def test_status_failed
      assert Payment.new(status: Payment::STATUS_FAILED).failed?
      assert !Payment.new(status: 'not-failed').failed?
    end

    def test_status_paid
      assert Payment.new(status: Payment::STATUS_PAID).paid?
      assert !Payment.new(status: nil).paid?
    end

    def test_status_authorized
      assert Payment.new(status: Payment::STATUS_AUTHORIZED).authorized?
      assert !Payment.new(status: 'not-authorized').authorized?
    end

    def test_refunded?
      assert Payment.new(amount_refunded: { value: '10.00', currency: 'EUR' }).refunded?
      assert Payment.new(amount_refunded: { value: '0.01', currency: 'EUR' }).refunded?
      assert_false Payment.new(amount_refunded: { value: '0', currency: 'EUR' }).refunded?
      assert_false Payment.new([]).refunded?
    end

    def test_payment_lines_attributes
      attributes = {
        resource: "payment",
        id: "tr_7UhSN1zuXS",
        lines: [{
          type: "physical",
          description: "LEGO 4440 Forest Police Station",
          quantity: 1,
          quantity_unit: "pcs",
          unit_price: { value: "89.00", currency: "EUR" },
          discount_amount: { value: "10.00", currency: "EUR" },
          recurring: {
            description: "A description of the recurring item.",
            interval: "3 months",
            amount: { value: "29.00", currency: "EUR" },
            times: 4,
            start_date: "2025-05-04"
          },
          total_amount: { value: "95.59", currency: "EUR" },
          vat_rate: "21.00",
          vat_amount: { value: "16.59", currency: "EUR" },
          sku: "SKU-12345",
          categories: ["eco", "meal", "gift", "sport_culture"],
          image_url: "https://example.org/lego-4440-forest-police-station.jpg",
          product_url: "https://example.org/lego-4440-forest-police-station"
        }]
      }

      payment = Payment.new(attributes)
      line = payment.lines.first

      assert_equal Payment::Line, line.class
      assert_equal "physical", line.type
      assert_equal "LEGO 4440 Forest Police Station", line.description
      assert_equal 1, line.quantity
      assert_equal "pcs", line.quantity_unit
      assert_equal 89.00, line.unit_price.value
      assert_equal "EUR", line.unit_price.currency
      assert_equal 10.00, line.discount_amount.value
      assert_equal "EUR", line.discount_amount.currency
      assert_equal 95.59, line.total_amount.value
      assert_equal "EUR", line.total_amount.currency
      assert_equal "21.00", line.vat_rate
      assert_equal 16.59, line.vat_amount.value
      assert_equal "EUR", line.vat_amount.currency
      assert_equal "SKU-12345", line.sku
      assert_equal ["eco", "meal", "gift", "sport_culture"], line.categories
      assert_equal "https://example.org/lego-4440-forest-police-station.jpg", line.image_url
      assert_equal "https://example.org/lego-4440-forest-police-station", line.product_url

      # Recurring object
      assert_equal "A description of the recurring item.", line.recurring.description
      assert_equal "3 months", line.recurring.interval
      assert_equal 29.00, line.recurring.amount.value
      assert_equal "EUR", line.recurring.amount.currency
      assert_equal 4, line.recurring.times
      assert_equal Date.parse("2025-05-04"), line.recurring.start_date
    end

    def test_billing_address
      attributes = {
        resource: "payment",
        id: "tr_7UhSN1zuXS",
        billing_address: {
          title: "Dhr",
          given_name: "Piet",
          family_name: "Mondriaan",
          organization_name: "Mollie B.V.",
          street_and_number: "Keizersgracht 313",
          street_additional: "apt",
          postal_code: "1234AB",
          email: "piet@mondriaan.com",
          phone: "+31208202070",
          city: "Amsterdam",
          region: "Noord-Holland",
          country: "NL"
        }
      }

      payment = Payment.new(attributes)
      assert_equal "Dhr", payment.billing_address.title
      assert_equal "Piet", payment.billing_address.given_name
      assert_equal "Mondriaan", payment.billing_address.family_name
      assert_equal "Mollie B.V.", payment.billing_address.organization_name
      assert_equal "Keizersgracht 313", payment.billing_address.street_and_number
      assert_equal "apt", payment.billing_address.street_additional
      assert_equal "1234AB", payment.billing_address.postal_code
      assert_equal "piet@mondriaan.com", payment.billing_address.email
      assert_equal "+31208202070", payment.billing_address.phone
      assert_equal "Amsterdam", payment.billing_address.city
      assert_equal "Noord-Holland", payment.billing_address.region
      assert_equal "NL", payment.billing_address.country
    end

    def test_shipping_address
      attributes = {
        resource: "payment",
        id: "tr_7UhSN1zuXS",
        shipping_address: {
          title: "Dhr",
          given_name: "Piet",
          family_name: "Mondriaan",
          organization_name: "Mollie B.V.",
          street_and_number: "Keizersgracht 313",
          street_additional: "apt",
          postal_code: "1234AB",
          email: "piet@mondriaan.com",
          phone: "+31208202070",
          city: "Amsterdam",
          region: "Noord-Holland",
          country: "NL"
        }
      }

      payment = Payment.new(attributes)
      assert_equal "Dhr", payment.shipping_address.title
      assert_equal "Piet", payment.shipping_address.given_name
      assert_equal "Mondriaan", payment.shipping_address.family_name
      assert_equal "Mollie B.V.", payment.shipping_address.organization_name
      assert_equal "Keizersgracht 313", payment.shipping_address.street_and_number
      assert_equal "apt", payment.shipping_address.street_additional
      assert_equal "1234AB", payment.shipping_address.postal_code
      assert_equal "piet@mondriaan.com", payment.shipping_address.email
      assert_equal "+31208202070", payment.shipping_address.phone
      assert_equal "Amsterdam", payment.shipping_address.city
      assert_equal "Noord-Holland", payment.shipping_address.region
      assert_equal "NL", payment.shipping_address.country
    end

    def test_create_payment
      stub_request(:post, 'https://api.mollie.com/v2/payments')
        .with(body: %({"amount":{"value":1.95,"currency":"EUR"}}))
        .to_return(status: 201, body: %({"id":"my-id", "amount":{ "value" : 1.95, "currency" : "EUR"}}), headers: {})

      payment = Payment.create(amount: { value: 1.95, currency: 'EUR' })

      assert_kind_of Mollie::Payment, payment
      assert_equal 'my-id', payment.id
      assert_equal BigDecimal('1.95'), payment.amount.value
      assert_equal 'EUR', payment.amount.currency
    end

    def test_create_payment_for_customer
      stub_request(:post, 'https://api.mollie.com/v2/payments')
        .with(body: %({"customerId":"cst_8wmqcHMN4U","amount":{"value":1.95,"currency":"EUR"}}))
        .to_return(status: 201, body: %({"id":"my-id", "amount":{ "value" : 1.95, "currency" : "EUR"}, "customerId":"cst_8wmqcHMN4U"}), headers: {})

      payment = Payment.create(
        customer_id: 'cst_8wmqcHMN4U',
        amount: { value: 1.95, currency: 'EUR' }
      )

      assert_kind_of Mollie::Payment, payment
      assert_equal 'cst_8wmqcHMN4U', payment.customer_id
    end

    def test_release_authorization
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
              "resource": "payment",
              "id": "tr_WDqYK6vllg"
          }
        ), headers: {})

      stub_request(:post, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/release-authorization')
        .to_return(status: 202, body: %({}), headers: {})

      payment = Payment.get('tr_WDqYK6vllg')
      assert payment.release_authorization
    end

    def test_refund!
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
              "resource": "payment",
              "id": "tr_WDqYK6vllg",
              "amount": {
                "value": "42.10",
                "currency": "EUR"
              }
          }
        ), headers: {})

      stub_request(:post, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds')
        .to_return(status: 200, body: %(
          {
              "resource": "refund",
              "id": "re_4qqhO89gsT"
          }
        ), headers: {})

      payment = Payment.get('tr_WDqYK6vllg')
      refund  = payment.refund!
      assert_equal 're_4qqhO89gsT', refund.id
    end

    def test_refund_with_custom_amount_and_description
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
              "resource": "payment",
              "id": "tr_WDqYK6vllg",
              "amount": {
                "value": "42.10",
                "currency": "EUR"
              }
          }
        ), headers: {})

      stub_request(:post, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds')
        .with(body: %({"amount":{"value":"9.95","currency":"EUR"},"description":"Test refund"}))
        .to_return(status: 200, body: %(
          {
              "resource": "refund",
              "id": "re_4qqhO89gsT"
          }
        ), headers: {})

      payment = Payment.get('tr_WDqYK6vllg')
      refund  = payment.refund!(
        amount: { value: '9.95', currency: 'EUR' },
        description: 'Test refund'
      )

      assert_equal 're_4qqhO89gsT', refund.id
    end

    def test_application_fee
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
            "application_fee": {
              "amount": {
                "value": "42.10",
                "currency": "EUR"
              },
              "description": "Example application fee"
            }
          }
        ), headers: {})

      payment = Payment.get('tr_WDqYK6vllg')
      assert_equal 42.10, payment.application_fee.amount.value
      assert_equal 'EUR', payment.application_fee.amount.currency
    end

    def test_restrict_payment_methods_to_country
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: read_fixture('payments/get.json'), headers: {})

      payment = Payment.get('tr_WDqYK6vllg')
      assert_equal 'NL', payment.restrict_payment_methods_to_country
    end

    def test_embedded_captures
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg?embed=captures')
        .to_return(status: 200, body: GET_PAYMENT_WITH_EMBEDDED_RESOURCES, headers: {})

      payment = Payment.get('tr_WDqYK6vllg', embed: 'captures')

      assert_equal 'cpt_mNepDkEtco6ah3QNPUGYH', payment.captures.first.id
      assert_equal 1, payment.captures.size
    end

    def test_embedded_chargebacks
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg?embed=chargebacks')
        .to_return(status: 200, body: GET_PAYMENT_WITH_EMBEDDED_RESOURCES, headers: {})

      payment = Payment.get('tr_WDqYK6vllg', embed: 'chargebacks')

      assert_equal 'chb_ls7ahg', payment.chargebacks.first.id
      assert_equal 1, payment.chargebacks.size
    end

    def test_embedded_refunds
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg?embed=refunds')
        .to_return(status: 200, body: GET_PAYMENT_WITH_EMBEDDED_RESOURCES, headers: {})

      payment = Payment.get('tr_WDqYK6vllg', embed: 'refunds')

      assert_equal 're_vD3Jm32wQt', payment.refunds.first.id
      assert_equal 1, payment.refunds.size
    end

    def test_list_refunds
      stub_request(:get, 'https://api.mollie.com/v2/payments/pay-id/refunds')
        .to_return(status: 200, body: %({"_embedded" : {"refunds" : [{"id":"ref-id", "payment_id":"pay-id"}]}}), headers: {})

      refunds = Payment.new(id: 'pay-id').refunds

      assert_equal 'ref-id', refunds.first.id
    end

    def test_list_chargebacks
      stub_request(:get, 'https://api.mollie.com/v2/payments/pay-id/chargebacks')
        .to_return(status: 200, body: %({"_embedded" : {"chargebacks" :[{"id":"chb-id", "payment_id":"pay-id"}]}}), headers: {})

      chargebacks = Payment.new(id: 'pay-id').chargebacks
      assert_equal 'chb-id', chargebacks.first.id
    end

    def test_list_captures
      stub_request(:get, 'https://api.mollie.com/v2/payments/pay-id/captures')
        .to_return(status: 200, body: %({"_embedded" : {"captures" :[{"id":"cpt-id", "payment_id":"pay-id"}]}}), headers: {})

      captures = Payment.new(id: 'pay-id').captures
      assert_equal 'cpt-id', captures.first.id
    end

    def test_get_settlement
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
              "resource": "payment",
              "id": "tr_WDqYK6vllg",
              "settlement_id": "stl_jDk30akdN"
          }
        ), headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/settlements/stl_jDk30akdN')
        .to_return(status: 200, body: %(
          {
              "resource": "settlement",
              "id": "stl_jDk30akdN"
          }
        ), headers: {})

      payment    = Payment.get('tr_WDqYK6vllg')
      settlement = payment.settlement
      assert_equal 'stl_jDk30akdN', settlement.id
    end

    def test_nil_settlement
      payment = Payment.new(id: 'tr_WDqYK6vllg')
      assert payment.settlement.nil?
    end

    def test_get_mandate
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
              "resource": "payment",
              "id": "tr_WDqYK6vllg",
              "customer_id": "cst_4qqhO89gsT",
              "mandate_id": "mdt_h3gAaD5zP"
          }
        ), headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/customers/cst_4qqhO89gsT/mandates/mdt_h3gAaD5zP')
        .to_return(status: 200, body: %(
          {
              "resource": "mandate",
              "id": "mdt_h3gAaD5zP"
          }
        ), headers: {})

      payment = Payment.get('tr_WDqYK6vllg')
      mandate = payment.mandate
      assert_equal 'mdt_h3gAaD5zP', mandate.id
    end

    def test_nil_mandate
      payment = Payment.new(id: 'tr_WDqYK6vllg')
      assert payment.mandate.nil?
    end

    def test_get_subscription
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
              "resource": "payment",
              "id": "tr_WDqYK6vllg",
              "subscription_id": "sub_rVKGtNd6s3",
              "customer_id": "cst_8wmqcHMN4U"
          }
        ), headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/subscriptions/sub_rVKGtNd6s3')
        .to_return(status: 200, body: %(
          {
              "resource": "subscription",
              "id": "sub_rVKGtNd6s3"
          }
        ), headers: {})

      payment = Payment.get('tr_WDqYK6vllg')
      subscription = payment.subscription
      assert_equal 'sub_rVKGtNd6s3', subscription.id
    end

    def test_nil_subscription
      payment = Payment.new(id: 'tr_WDqYK6vllg')
      assert payment.subscription.nil?

      payment = Payment.new(id: 'tr_WDqYK6vllg', customer_id: 'cst_8wmqcHMN4U')
      assert payment.subscription.nil?

      payment = Payment.new(id: 'tr_WDqYK6vllg', subscription_id: 'sub_rVKGtNd6s3')
      assert payment.subscription.nil?
    end

    def test_get_customer
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
              "resource": "payment",
              "id": "tr_WDqYK6vllg",
              "customer_id": "cst_8wmqcHMN4U"
          }
        ), headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U')
        .to_return(status: 200, body: %(
          {
              "resource": "customer",
              "id": "cst_8wmqcHMN4U"
          }
        ), headers: {})

      payment  = Payment.get('tr_WDqYK6vllg')
      customer = payment.customer
      assert_equal 'cst_8wmqcHMN4U', customer.id
    end

    def test_nil_customer
      payment = Payment.new(id: 'tr_WDqYK6vllg')
      assert payment.customer.nil?
    end

    def test_get_order
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
              "resource": "payment",
              "id": "tr_WDqYK6vllg",
              "order_id": "ord_kEn1PlbGa"
          }
        ), headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/orders/ord_kEn1PlbGa')
        .to_return(status: 200, body: %(
          {
              "resource": "order",
              "id": "ord_kEn1PlbGa"
          }
        ), headers: {})

      payment = Payment.get('tr_WDqYK6vllg')
      order = payment.order
      assert_equal 'ord_kEn1PlbGa', order.id
    end

    def test_nil_order
      payment = Payment.new(id: 'tr_WDqYK6vllg')
      assert payment.order.nil?
    end
  end
end

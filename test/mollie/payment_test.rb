require 'helper'

module Mollie
  class PaymentTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:               'tr_WDqYK6vllg',
        mode:             'test',
        created_datetime: '2016-10-08T10:10:52.0Z',
        status:           'paid',
        paid_datetime:    '2016-10-08T10:15:35.0Z',
        amount:           35.07,
        description:      'Order 33',
        method:           'ideal',
        metadata:         {
          order_id: '33'
        },
        details:          {
          consumer_name:    "Hr E G H K\u00fcppers en\/of MW M.J. K\u00fcppers-Veeneman",
          consumer_account: 'NL53INGB0618365937',
          consumer_bic:     'INGBNL2A'
        },
        locale:           'nl',
        profile_id:       'pfl_QkEhN94Ba',
        links:            {
          'webhook_url'  => 'https://webshop.example.org/payments/webhook',
          'redirect_url' => 'https://webshop.example.org/order/33/',
          'payment_url'  => 'https://webshop.example.org/payment/tr_WDqYK6vllg',
          'settlement'   => 'https://webshop.example.org/payment/tr_WDqYK6vllg/settlement',
          'refunds'      => 'https://webshop.example.org/payment/tr_WDqYK6vllg/refunds',
        }
      }

      payment = Payment.new(attributes)

      assert_equal 'tr_WDqYK6vllg', payment.id
      assert_equal 'test', payment.mode
      assert_equal Time.parse('2016-10-08T10:10:52.0Z'), payment.created_datetime
      assert_equal 'paid', payment.status
      assert_equal Time.parse('2016-10-08T10:15:35.0Z'), payment.paid_datetime
      assert_equal 35.07, payment.amount
      assert_equal 'Order 33', payment.description
      assert_equal 'ideal', payment.method
      assert_equal '33', payment.metadata.order_id
      assert_equal "Hr E G H K\u00fcppers en\/of MW M.J. K\u00fcppers-Veeneman", payment.details.consumer_name
      assert_equal 'NL53INGB0618365937', payment.details.consumer_account
      assert_equal 'INGBNL2A', payment.details.consumer_bic
      assert_equal 'nl', payment.locale
      assert_equal 'pfl_QkEhN94Ba', payment.profile_id
      assert_equal 'https://webshop.example.org/payments/webhook', payment.webhook_url
      assert_equal 'https://webshop.example.org/order/33/', payment.redirect_url
      assert_equal 'https://webshop.example.org/payment/tr_WDqYK6vllg', payment.payment_url
      assert_equal 'https://webshop.example.org/payment/tr_WDqYK6vllg/settlement', payment.settlement
      assert_equal 'https://webshop.example.org/payment/tr_WDqYK6vllg/refunds', payment.refunds_url
    end

    def test_status_open
      assert Payment.new(status: Payment::STATUS_OPEN).open?
      assert !Payment.new(status: 'not-open').open?
    end

    def test_status_cancelled
      assert Payment.new(status: Payment::STATUS_CANCELLED).cancelled?
      assert !Payment.new(status: 'not-cancelled').cancelled?
    end

    def test_status_expired
      assert Payment.new(status: Payment::STATUS_EXPIRED).expired?
      assert !Payment.new(status: 'not-expired').expired?
    end

    def test_status_paidout
      assert Payment.new(status: Payment::STATUS_PAIDOUT).paidout?
      assert !Payment.new(status: 'not-paidout').paidout?
    end

    def test_status_refunded
      assert Payment.new(status: Payment::STATUS_REFUNDED).refunded?
      assert !Payment.new(status: 'not-refunded').refunded?
    end

    def test_status_paid
      assert Payment.new(paid_datetime: Time.now).paid?
      assert !Payment.new(paid_datetime: nil).paid?
    end

    def test_status_failed
      assert Payment.new(status: Payment::STATUS_FAILED).failed?
      assert !Payment.new(status: 'not-failed').failed?
    end

    def test_status_pending
      assert Payment.new(status: Payment::STATUS_PENDING).pending?
      assert !Payment.new(status: 'not-pending').pending?
    end

    def test_status_charged_back
      assert Payment.new(status: Payment::STATUS_CHARGED_BACK).charged_back?
      assert !Payment.new(status: 'not-charged-back').charged_back?
    end

    def test_list_refunds
      stub_request(:get, "https://api.mollie.nl/v1/payments/pay-id/refunds?count=50&offset=0")
        .to_return(:status => 200, :body => %{{"data" : [{"id":"ref-id", "payment_id":"pay-id"}]}}, :headers => {})

      refunds = Payment.new(id: "pay-id").refunds.all

      assert_equal "ref-id", refunds.first.id
    end

    def test_create_refund
      stub_request(:post, "https://api.mollie.nl/v1/payments/pay-id/refunds")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "amount":1.95}}, :headers => {})

      refund = Payment.new(id: "pay-id").refunds.create(amount: 1.95)

      assert_equal "my-id", refund.id
      assert_equal BigDecimal.new("1.95"), refund.amount
    end

    def test_delete_refund
      stub_request(:delete, "https://api.mollie.nl/v1/payments/pay-id/refunds/ref-id")
        .to_return(:status => 204, :headers => {})

      refund = Payment.new(id: "pay-id").refunds.delete("ref-id")
      assert_equal nil, refund
    end

    def test_get_refund
      stub_request(:get, "https://api.mollie.nl/v1/payments/pay-id/refunds/ref-id")
        .to_return(:status => 200, :body => %{{"id":"ref-id", "payment":{"id":"pay-id"}}}, :headers => {})

      refund = Payment.new(id: "pay-id").refunds.get("ref-id")

      assert_equal "ref-id", refund.id
      assert_equal "pay-id", refund.payment.id
    end
  end
end

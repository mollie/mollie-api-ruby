require 'helper'

module Mollie
  class RefundTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:          're_4qqhO89gsT',
        amount:      { 'value' => '5.95', 'currency' => 'EUR' },
        status:      'pending',
        created_at:  '2016-10-08T07:59:53.0Z',
        description: 'Order',
        payment_id:  'tr_WDqYK6vllg',
        settlement_amount: { 'value' => '-5.95', 'currency' => 'EUR' }
      }

      refund = Refund.new(attributes)

      assert_equal 're_4qqhO89gsT', refund.id
      assert_equal BigDecimal('5.95'), refund.amount.value
      assert_equal 'EUR', refund.amount.currency
      assert_equal Refund::STATUS_PENDING, refund.status
      assert_equal Time.parse('2016-10-08T07:59:53.0Z'), refund.created_at
      assert_equal 'Order', refund.description
      assert_equal 'tr_WDqYK6vllg', refund.payment_id
      assert_equal BigDecimal('-5.95'), refund.settlement_amount.value
      assert_equal 'EUR', refund.settlement_amount.currency
    end

    def test_pending?
      assert Refund.new(status: Refund::STATUS_PENDING).pending?
      assert !Refund.new(status: 'not-pending').pending?
    end

    def test_processing?
      assert Refund.new(status: Refund::STATUS_PROCESSING).processing?
      assert !Refund.new(status: 'not-processing').processing?
    end

    def test_refunded?
      assert Refund.new(status: Refund::STATUS_REFUNDED).refunded?
      assert !Refund.new(status: 'not-refunded').refunded?
    end

    def test_failed?
      assert Refund.new(status: Refund::STATUS_FAILED).failed?
      assert !Refund.new(status: 'not-failed').failed?
    end

    def test_get_refund
      stub_request(:get, 'https://api.mollie.com/v2/payments/pay-id/refunds/ref-id')
        .to_return(status: 200, body: %({"id":"ref-id"}), headers: {})

      refund = Payment::Refund.get('ref-id', payment_id: 'pay-id')
      assert_equal 'ref-id', refund.id
    end

    def test_delete_refund
      stub_request(:delete, 'https://api.mollie.com/v2/payments/pay-id/refunds/ref-id')
        .to_return(status: 204, headers: {})

      refund = Payment::Refund.delete('ref-id', payment_id: 'pay-id')
      assert_equal nil, refund
    end

    def test_order_lines
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT')
        .to_return(status: 200, body: read_fixture('refunds/get.json'), headers: {})

      refund = Payment::Refund.get('re_4qqhO89gsT', payment_id: 'tr_WDqYK6vllg')
      assert refund.lines.size == 2

      line = refund.lines.first
      assert_equal 'odl_d1ec55', line.id
      assert_equal 'ord_stTC2WHAuS', line.order_id
      assert_equal 'LEGO 42083 Bugatti Chiron', line.name
      assert_equal 'https://shop.lego.com/nl-NL/Bugatti-Chiron-42083', line.product_url
      assert_equal 'https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$', line.image_url
      assert_equal '5702016116977', line.sku
      assert_equal 'physical', line.type
      assert_equal 'completed', line.status
      assert_equal false, line.is_cancelable
      assert_equal false, line.cancelable?
      assert_equal 2, line.quantity
      assert_equal '21.00', line.vat_rate

      assert_equal BigDecimal('399.0'), line.unit_price.value
      assert_equal 'EUR', line.unit_price.currency

      assert_equal BigDecimal('121.14'), line.vat_amount.value
      assert_equal 'EUR', line.vat_amount.currency

      assert_equal BigDecimal('100.0'), line.discount_amount.value
      assert_equal 'EUR', line.discount_amount.currency

      assert_equal BigDecimal('698.0'), line.total_amount.value
      assert_equal 'EUR', line.total_amount.currency

      assert_equal Time.parse('2018-09-23T17:23:13+00:00'), line.created_at
    end

    def test_get_payment
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT')
        .to_return(status: 200, body: %(
          {
            "resource": "refund",
            "id": "re_4qqhO89gsT",
            "paymentId": "tr_WDqYK6vllg"
          }
        ), headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
        .to_return(status: 200, body: %(
          {
            "resource": "payment",
            "id": "tr_WDqYK6vllg"
          }
        ), headers: {})

      refund = Payment::Refund.get('re_4qqhO89gsT', payment_id: 'tr_WDqYK6vllg')
      assert_equal 'tr_WDqYK6vllg', refund.payment.id
    end

    def test_get_settlement
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT')
        .to_return(status: 200, body: %(
          {
            "resource": "refund",
            "id": "re_4qqhO89gsT",
            "paymentId": "tr_WDqYK6vllg",
            "_links": {
              "settlement": {
                "href": "https://api.mollie.com/v2/settlements/stl_jDk30akdN",
                "type": "application/hal+json"
              }
            }
          }
        ), headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/settlements/stl_jDk30akdN')
        .to_return(status: 200, body: %(
          {
            "resource": "settlement",
            "id": "stl_jDk30akdN"
          }
        ), headers: {})

      chargeback = Payment::Refund.get('re_4qqhO89gsT', payment_id: 'tr_WDqYK6vllg')
      assert_equal 'stl_jDk30akdN', chargeback.settlement.id
    end

    def test_nil_settlement
      refund = Payment::Refund.new(id: 'tr_WDqYK6vllg')
      assert refund.settlement.nil?
    end

    def test_get_order
      stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT')
        .to_return(status: 200, body: %(
          {
              "resource": "refund",
              "id": "re_4qqhO89gsT",
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

      refund = Payment::Refund.get('re_4qqhO89gsT', payment_id: 'tr_WDqYK6vllg')
      order = refund.order
      assert_equal 'ord_kEn1PlbGa', order.id
    end

    def test_nil_order
      refund = Payment::Refund.new(id: 're_4qqhO89gsT')
      assert refund.order.nil?
    end
  end
end

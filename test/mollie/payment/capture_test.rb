require 'helper'

module Mollie
  class Payment
    class CaptureTest < Test::Unit::TestCase
      GET_CAPTURE = read_fixture('captures/get.json')
      LIST_CAPTURES = read_fixture('captures/list.json')

      PAYMENT_STUB    = %({ "resource": "payment", "id": "tr_WDqYK6vllg" })
      SHIPMENT_STUB   = %({ "resource": "shipment", "id": "shp_3wmsgCJN4U" })
      SETTLEMENT_STUB = %({ "resource": "settlement", "id": "stl_jDk30akdN" })

      def test_get_capture
        stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/captures/cpt_4qqhO89gsT')
          .to_return(status: 200, body: GET_CAPTURE, headers: {})

        capture  = Payment::Capture.get('cpt_4qqhO89gsT', payment_id: 'tr_WDqYK6vllg')
        assert_equal 'cpt_4qqhO89gsT', capture.id
        assert_equal 'live', capture.mode
        assert_equal BigDecimal('1027.99'), capture.amount.value
        assert_equal 'EUR', capture.amount.currency
        assert_equal BigDecimal('399'), capture.settlement_amount.value
        assert_equal 'EUR', capture.settlement_amount.currency
        assert_equal 'tr_WDqYK6vllg', capture.payment_id
        assert_equal 'shp_3wmsgCJN4U', capture.shipment_id
        assert_equal 'stl_jDk30akdN', capture.settlement_id
        assert_equal Time.parse('2018-08-02T09:29:56+00:00'), capture.created_at
      end

      def test_list_captures
        stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/captures')
          .to_return(status: 200, body: LIST_CAPTURES, headers: {})

        captures = Payment::Capture.all(payment_id: 'tr_WDqYK6vllg')
        assert_equal 1, captures.size
        assert_equal 'cpt_4qqhO89gsT', captures.first.id
        assert_equal 'tr_WDqYK6vllg', captures.first.payment_id
      end

      def test_get_payment
        stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/captures/cpt_4qqhO89gsT')
          .to_return(status: 200, body: GET_CAPTURE, headers: {})

        stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg')
          .to_return(status: 200, body: PAYMENT_STUB, headers: {})

        capture = Payment::Capture.get('cpt_4qqhO89gsT', payment_id: 'tr_WDqYK6vllg')
        assert_equal 'cpt_4qqhO89gsT', capture.id
        assert_equal 'tr_WDqYK6vllg', capture.payment.id
      end

      def test_get_shipment
        stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/captures/cpt_4qqhO89gsT')
          .to_return(status: 200, body: GET_CAPTURE, headers: {})

        stub_request(:get, 'https://api.mollie.com/v2/shipments/shp_3wmsgCJN4U')
          .to_return(status: 200, body: SHIPMENT_STUB, headers: {})

        capture = Payment::Capture.get('cpt_4qqhO89gsT', payment_id: 'tr_WDqYK6vllg')
        assert_equal 'cpt_4qqhO89gsT', capture.id
        assert_equal 'shp_3wmsgCJN4U', capture.shipment.id
      end

      def test_get_settlement
        stub_request(:get, 'https://api.mollie.com/v2/payments/tr_WDqYK6vllg/captures/cpt_4qqhO89gsT')
          .to_return(status: 200, body: GET_CAPTURE, headers: {})

        stub_request(:get, 'https://api.mollie.com/v2/settlements/stl_jDk30akdN')
          .to_return(status: 200, body: SETTLEMENT_STUB, headers: {})

        capture = Payment::Capture.get('cpt_4qqhO89gsT', payment_id: 'tr_WDqYK6vllg')
        assert_equal 'cpt_4qqhO89gsT', capture.id
        assert_equal 'stl_jDk30akdN', capture.settlement.id
      end
    end
  end
end

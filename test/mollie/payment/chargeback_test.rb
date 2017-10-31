require 'helper'

module Mollie
  class Payment
    class ChargebackTest < Test::Unit::TestCase
      def test_kind_of_refund
        chargeback = Mollie::Payment::Chargeback.new({})
        assert_kind_of Mollie::Chargeback, chargeback
      end

      def test_list_chargebacks
        stub_request(:get, "https://api.mollie.nl/v1/payments/pay-id/chargebacks?count=50&offset=0")
          .to_return(:status => 200, :body => %{{"data" : [{"id":"re-id", "payment": {"id":"pay-id"}}]}}, :headers => {})

        chargebacks = Mollie::Payment::Chargeback.all(payment_id: "pay-id")

        assert_equal "re-id", chargebacks.first.id
        assert_equal "pay-id", chargebacks.first.payment.id
      end
    end
  end
end

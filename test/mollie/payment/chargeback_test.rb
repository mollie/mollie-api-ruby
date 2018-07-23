require 'helper'

module Mollie
  class Payment
    class ChargebackTest < Test::Unit::TestCase
      def test_kind_of_refund
        chargeback = Mollie::Payment::Chargeback.new({})
        assert_kind_of Mollie::Chargeback, chargeback
      end

      def test_list_chargebacks
        stub_request(:get, "https://api.mollie.com/v2/payments/pay-id/chargebacks")
          .to_return(:status => 200, :body => %{{"_embedded" : {"chargebacks" : [{"id":"re-id"}]}}}, :headers => {})

        chargebacks = Mollie::Payment::Chargeback.all(payment_id: "pay-id")

        assert_equal "re-id", chargebacks.first.id
      end
    end
  end
end

require 'helper'

module Mollie
  class Payment
    class RefundTest < Test::Unit::TestCase
      def test_kind_of_refund
        refund = Mollie::Payment::Refund.new({})
        assert_kind_of Mollie::Refund, refund
      end

      def test_list_refunds
        stub_request(:get, "https://api.mollie.nl/v1/payments/pay-id/refunds?count=50&offset=0")
          .to_return(:status => 200, :body => %{{"data" : [{"id":"re-id", "payment": {"id":"pay-id"}}]}}, :headers => {})

        refunds = Mollie::Payment::Refund.all(payment_id: "pay-id")

        assert_equal "re-id", refunds.first.id
        assert_equal "pay-id", refunds.first.payment.id
      end
    end
  end
end

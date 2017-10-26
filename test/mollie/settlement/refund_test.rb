require 'helper'

module Mollie
  class Settlement
    class RefundTest < Test::Unit::TestCase
      def test_kind_of_refund
        refund = Mollie::Settlement::Refund.new({})
        assert_kind_of Mollie::Payment::Refund, refund
      end

      def test_list_refunds
        stub_request(:get, "https://api.mollie.nl/v1/settlements/set-id/refunds?count=50&offset=0")
          .to_return(:status => 200, :body => %{{"data" : [{"id":"re-id", "payment": {"id":"pay-id"}}]}}, :headers => {})

        refunds = Mollie::Settlement::Refund.all(settlement_id: "set-id")

        assert_equal "re-id", refunds.first.id
        assert_equal "pay-id", refunds.first.payment.id
      end
    end
  end
end

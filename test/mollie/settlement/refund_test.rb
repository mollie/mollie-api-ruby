require 'helper'

module Mollie
  class Settlement
    class RefundTest < Test::Unit::TestCase
      def test_kind_of_refund
        refund = Mollie::Settlement::Refund.new({})
        assert_kind_of Mollie::Refund, refund
      end

      def test_list_refunds
        stub_request(:get, "https://api.mollie.nl/v2/settlements/set-id/refunds")
          .to_return(:status => 200, :body => %{{"_embedded" : {"refunds" : [{"id":"re-id"}]}}}, :headers => {})

        refunds = Mollie::Settlement::Refund.all(settlement_id: "set-id")

        assert_equal "re-id", refunds.first.id
      end
    end
  end
end

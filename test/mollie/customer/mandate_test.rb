require 'helper'

module Mollie
  class Customer
    class MandateTest < Test::Unit::TestCase
      def test_setting_attributes
        attributes = {
          id:               "mdt_qtUgejVgMN",
          status:           "valid",
          method:           "creditcard",
          customer_id:      "cst_R6JLAuqEgm",
          details:          {
            card_holder:      "John Doe",
            card_expiry_date: "2016-03-31"
          },
          mandate_reference: "YOUR-COMPANY-MD1380",
          signature_date: "2018-05-07",
          created_at: "2016-04-13T11:32:38.0Z"
        }

        mandate = Mandate.new(attributes)

        assert_equal 'mdt_qtUgejVgMN', mandate.id
        assert_equal 'valid', mandate.status
        assert_equal 'creditcard', mandate.method
        assert_equal 'cst_R6JLAuqEgm', mandate.customer_id
        assert_equal 'YOUR-COMPANY-MD1380', mandate.mandate_reference
        assert_equal '2018-05-07', mandate.signature_date
        assert_equal Time.parse('2016-04-13T11:32:38.0Z'), mandate.created_at

        assert_equal 'John Doe', mandate.details.card_holder
        assert_equal '2016-03-31', mandate.details.card_expiry_date
        assert_equal nil, mandate.details.non_existing
      end

      def test_valid_invalid_pending
        mandate = Mandate.new(status: Mandate::STATUS_VALID)
        assert mandate.valid?

        mandate = Mandate.new(status: Mandate::STATUS_INVALID)
        assert mandate.invalid?

        mandate = Mandate.new(status: Mandate::STATUS_PENDING)
        assert mandate.pending?
      end
    end
  end
end

require 'helper'

module Mollie
  module API
    module Object
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
                created_datetime: "2016-04-13T11:32:38.0Z"
            }

            mandate = Mandate.new(attributes)

            assert_equal 'mdt_qtUgejVgMN', mandate.id
            assert_equal 'valid', mandate.status
            assert_equal 'creditcard', mandate.method
            assert_equal 'cst_R6JLAuqEgm', mandate.customer_id
            assert_equal Time.parse('2016-04-13T11:32:38.0Z'), mandate.created_datetime

            assert_equal 'John Doe', mandate.details.card_holder
            assert_equal '2016-03-31', mandate.details.card_expiry_date
            assert_equal nil, mandate.details.non_existing
          end

          def test_valid_invalid
            mandate = Mandate.new(status: Mandate::STATUS_VALID)
            assert mandate.valid?
            assert !mandate.invalid?

            mandate = Mandate.new(status: Mandate::STATUS_INVALID)
            assert !mandate.valid?
            assert mandate.invalid?
          end
        end
      end
    end
  end
end

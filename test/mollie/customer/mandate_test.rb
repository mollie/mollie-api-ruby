require 'helper'

module Mollie
  class Customer
    class MandateTest < Test::Unit::TestCase
      def test_setting_attributes
        attributes = {
          id:               'mdt_h3gAaD5zP',
          status:           'valid',
          method:           'creditcard',
          details:          {
            card_holder:      'John Doe',
            card_expiry_date: '2016-03-31'
          },
          mandate_reference: 'YOUR-COMPANY-MD1380',
          signature_date: '2018-05-07',
          created_at: '2016-04-13T11:32:38.0Z',
          _links: {
            'self' => {
              'href' => 'https://api.mollie.com/v2/customers/cst_4qqhO89gsT/mandates/mdt_h3gAaD5zP',
              'type' => 'application/hal+json'
            },
            'customer' => {
              'href' => 'https://api.mollie.com/v2/customers/cst_4qqhO89gsT',
              'type' => 'application/hal+json'
            },
            'documentation' => {
              'href' => 'https://docs.mollie.com/reference/v2/mandates-api/get-mandate',
              'type' => 'text/html'
            }
          }
        }

        mandate = Mandate.new(attributes)

        assert_equal 'mdt_h3gAaD5zP', mandate.id
        assert_equal 'valid', mandate.status
        assert_equal 'creditcard', mandate.method
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

      def test_get_mandate
        stub_request(:get, 'https://api.mollie.com/v2/customers/cus-id/mandates/man-id')
          .to_return(status: 200, body: %({"id":"man-id", "method":"directdebit"}), headers: {})

        mandate = Customer::Mandate.get('man-id', customer_id: 'cus-id')

        assert_equal 'man-id', mandate.id
        assert_equal 'directdebit', mandate.method
      end

      def test_create_mandate
        stub_request(:post, 'https://api.mollie.com/v2/customers/cus-id/mandates')
          .with(body: %({"method":"directdebit"}))
          .to_return(status: 201, body: %({"id":"my-id", "method":"directdebit"}), headers: {})

        mandate = Customer::Mandate.create(
          method: 'directdebit',
          customer_id: 'cus-id'
        )

        assert_equal 'my-id', mandate.id
        assert_equal 'directdebit', mandate.method
      end

      def test_delete_mandate
        stub_request(:delete, 'https://api.mollie.com/v2/customers/cus-id/mandates/man-id')
          .to_return(status: 204, headers: {})

        mandate = Customer::Mandate.delete('man-id', customer_id: 'cus-id')
        assert_equal nil, mandate
      end

      def test_get_customer
        stub_request(:get, 'https://api.mollie.com/v2/customers/cst_4qqhO89gsT/mandates/mdt_h3gAaD5zP')
          .to_return(status: 200, body: %(
            {
              "resource": "mandate",
              "id": "mdt_h3gAaD5zP",
              "_links": {
                "customer": {
                  "href": "https://api.mollie.com/v2/customers/cst_4qqhO89gsT",
                  "type": "application/hal+json"
                }
              }
            }
          ), headers: {})

        stub_request(:get, 'https://api.mollie.com/v2/customers/cst_4qqhO89gsT')
          .to_return(status: 200, body: %(
            {
              "resource": "customer",
              "id": "cst_4qqhO89gsT"
            }
          ), headers: {})

        mandate = Customer::Mandate.get('mdt_h3gAaD5zP', customer_id: 'cst_4qqhO89gsT')
        assert_equal 'cst_4qqhO89gsT', mandate.customer.id
      end
    end
  end
end

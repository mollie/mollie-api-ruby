require 'helper'

module Mollie
  class ListTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        '_embedded' => { 'payments' => [
          { 'id' => 'tr_1' },
          { 'id' => 'tr_2' }
        ] },
        'count'       => 2,
        '_links'      => {
          'self' => {
            'href' => 'https://api.mollie.com/v2/payments?limit=5',
            'type' => 'application/hal+json'
          },
          'previous' => {
            'href' => 'https://api.mollie.com/v2/payments?from=tr_1&limit=1',
            'type' => 'application/hal+json'
          },
          'next' => {
            'href' => 'https://api.mollie.com/v2/payments?from=tr_2&limit=1',
            'type' => 'application/hal+json'
          },
          'documentation' => {
            'href' => 'https://docs.mollie.com/reference/payments/list',
            'type' => 'text/html'
          }
        }
      }

      list = Mollie::List.new(attributes, Payment)

      assert_equal 2, list.count
      assert_equal 2, list.size
      assert_kind_of Payment, list.to_a[0]
      assert_equal 'tr_1', list.to_a[0].id
      assert_equal 'tr_1', list[0].id

      assert_kind_of Payment, list.to_a[1]
      assert_equal 'tr_2', list.to_a[1].id
      assert_equal 'tr_2', list[1].id
    end

    def test_next_page
      stub_request(:get, 'https://api.mollie.com/v2/payments?from=tr_WDqYK6vllg&limit=10')
        .to_return(
          status: 200,
          body: %({"_embedded":{"payments":[{"id":"tr_1"},{"id":"tr_2"}]},"count":2}),
          headers: {}
        )

      attributes = {
        '_links' => {
          'next' => {
            'href' => 'https://api.mollie.com/v2/payments?from=tr_WDqYK6vllg&limit=10',
            'type' => 'application/hal+json'
          }
        }
      }

      list = Mollie::List.new(attributes, Payment)
      assert_equal 2, list.next.count
    end

    def test_previous_page
      stub_request(:get, 'https://api.mollie.com/v2/payments?from=tr_SDkzMggpvx&limit=10')
        .to_return(
          status: 200,
          body: %({"_embedded":{"payments":[{"id":"tr_1"},{"id":"tr_2"}]},"count":2}),
          headers: {}
        )

      attributes = {
        '_links' => {
          'previous' => {
            'href' => 'https://api.mollie.com/v2/payments?from=tr_SDkzMggpvx&limit=10',
            'type' => 'application/hal+json'
          }
        }
      }

      list = Mollie::List.new(attributes, Payment)
      assert_equal 2, list.previous.count
    end

    def test_pagination_for_nested_resources
      stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U')
        .to_return(
          status: 200,
          body: read_fixture('customer/get.json'),
          headers: {}
        )

      # First page of customer payments
      stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/payments?limit=2')
        .to_return(
          status: 200,
          body: read_fixture('customer/list-payments.json'),
          headers: {}
        )

      # Second page
      stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/payments?from=tr_3&limit=2')
        .to_return(
          status: 200,
          body: read_fixture('customer/list-payments-next.json'),
          headers: {}
        )

      # Previous page
      stub_request(:get, 'https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/payments?from=tr_1&limit=2')
        .to_return(
          status: 200,
          body: read_fixture('customer/list-payments.json'),
          headers: {}
        )

      customer = Mollie::Customer.get('cst_8wmqcHMN4U')

      # First page of customer payments
      payments = customer.payments(limit: 2)

      assert_equal ["tr_1", "tr_2"], payments.map { |p| p.id }
      assert_equal "https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/payments?from=tr_3&limit=2",
        payments.links["next"]["href"]
      assert_equal nil, payments.links["previous"]

      # Second page
      payments = payments.next

      assert_equal ["tr_3", "tr_4"], payments.map { |p| p.id }
      assert_equal nil, payments.links["next"]
      assert_equal "https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/payments?from=tr_1&limit=2",
      payments.links["previous"]["href"]

      # Previous page
      payments = payments.previous

      assert_equal ["tr_1", "tr_2"], payments.map { |p| p.id }
      assert_equal "https://api.mollie.com/v2/customers/cst_8wmqcHMN4U/payments?from=tr_3&limit=2",
        payments.links["next"]["href"]
      assert_equal nil, payments.links["previous"]
    end

  end
end

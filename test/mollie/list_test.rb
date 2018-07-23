require 'helper'

module Mollie
  class ListTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        '_embedded'   => { "payments" => [
          { 'id' => "tr_1" },
          { 'id' => "tr_2" },
        ] },
        'count'       => 2,
        '_links'      => {
          "self"          => {
            "href" => "https://api.mollie.com/v2/payments?limit=5",
            "type" => "application/hal+json"
          },
          "previous"      => {
            "href" => "https://api.mollie.com/v2/payments?from=tr_1&limit=1",
            "type" => "application/hal+json"
          },
          "next"          => {
            "href" => "https://api.mollie.com/v2/payments?from=tr_2&limit=1",
            "type" => "application/hal+json"
          },
          "documentation" => {
            "href" => "https://docs.mollie.com/reference/payments/list",
            "type" => "text/html"
          }
        }
      }

      list = Mollie::List.new(attributes, Payment)

      assert_equal 2, list.count
      assert_kind_of Payment, list.to_a[0]
      assert_equal "tr_1", list.to_a[0].id

      assert_kind_of Payment, list.to_a[1]
      assert_equal "tr_2", list.to_a[1].id
    end

    def test_next_page
      stub_request(:get, "https://api.mollie.com/v2/payments?from=tr_WDqYK6vllg&limit=10").
        to_return(
          status: 200,
          body: %{{"_embedded":{"payments":[{"id":"tr_1"},{"id":"tr_2"}]},"count":2}},
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
      stub_request(:get, "https://api.mollie.com/v2/payments?from=tr_SDkzMggpvx&limit=10").
        to_return(
          status: 200,
          body: %{{"_embedded":{"payments":[{"id":"tr_1"},{"id":"tr_2"}]},"count":2}},
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
  end
end

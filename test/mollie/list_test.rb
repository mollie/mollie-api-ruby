require 'helper'

module Mollie
  class ListTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        'total_count' => 280,
        'offset'      => 0,
        'count'       => 10,
        '_embedded'   => { "payments" => [
          { 'id' => "tr_1" },
          { 'id' => "tr_2" },
        ] },
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

      assert_equal 280, list.total_count
      assert_equal 0, list.offset
      assert_equal 10, list.count

      assert_kind_of Payment, list.to_a[0]
      assert_equal "tr_1", list.to_a[0].id

      assert_kind_of Payment, list.to_a[1]
      assert_equal "tr_2", list.to_a[1].id

      assert_equal "https://api.mollie.com/v2/payments?from=tr_1&limit=1", list.previous_url
      assert_equal "https://api.mollie.com/v2/payments?from=tr_2&limit=1", list.next_url
    end
  end
end

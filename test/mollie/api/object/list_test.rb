require 'helper'

module Mollie
  module API
    module Object
      class ListTest < Test::Unit::TestCase
        def test_setting_attributes
          attributes = {
              'total_count' => 280,
              'offset'      => 0,
              'count'       => 10,
              'data'        => [
                  { 'id' => "tr_1" },
                  { 'id' => "tr_2" },
              ],
              'links'       => {
                  'first'    => "https://api.mollie.nl/v1/payments?count=10&offset=0",
                  'previous' => nil,
                  'next'     => "https://api.mollie.nl/v1/payments?count=10&offset=10",
                  'last'     => "https://api.mollie.nl/v1/payments?count=10&offset=270"
              }
          }

          list = List.new(attributes, Payment)

          assert_equal 280, list.total_count
          assert_equal 0, list.offset
          assert_equal 10, list.count

          assert_kind_of Payment, list.to_a[0]
          assert_equal "tr_1", list.to_a[0].id

          assert_kind_of Payment, list.to_a[1]
          assert_equal "tr_2", list.to_a[1].id

          assert_equal "https://api.mollie.nl/v1/payments?count=10&offset=0", list.first_url
          assert_equal nil, list.previous_url
          assert_equal "https://api.mollie.nl/v1/payments?count=10&offset=10", list.next_url
          assert_equal "https://api.mollie.nl/v1/payments?count=10&offset=270", list.last_url
        end
      end
    end
  end
end

require 'helper'

module Mollie
  class UtilTest < Test::Unit::TestCase

    def test_extract_id
      links = {
        "customer" => {
          "href" => "https://api.mollie.com/v2/customers/cst_4qqhO89gsT",
          "type"=>"application/hal+json"
        }
      }

      customer_id = Util.extract_id(links, "customer")
      assert_equal "cst_4qqhO89gsT", customer_id
    end

    def test_extract_id_missing_link
      links = {
        "customer" => {
          "href" => "https://api.mollie.com/v2/customers/cst_4qqhO89gsT",
          "type"=>"application/hal+json"
        }
      }

      customer_id = Util.extract_id(links, "unknown-resource")
      assert_nil customer_id
    end

  end
end

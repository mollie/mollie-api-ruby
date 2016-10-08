require 'helper'

module Mollie
  module API
    module Resource
      class IssuersTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Issuer, Issuers.new(nil).resource_object
        end
      end
    end
  end
end

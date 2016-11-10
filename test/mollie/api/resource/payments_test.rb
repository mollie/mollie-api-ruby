require 'helper'

module Mollie
  module API
    module Resource
      class PaymentsTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Payment, Payments.new(nil).resource_object
        end
      end
    end
  end
end

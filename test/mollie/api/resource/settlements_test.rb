require 'helper'

module Mollie
  module API
    module Resource
      class SettlementsTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Settlement, Settlements.new(nil).resource_object
        end
      end
    end
  end
end

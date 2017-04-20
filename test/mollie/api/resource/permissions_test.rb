require 'helper'

module Mollie
  module API
    module Resource
      class PermissionsTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Permission, Permissions.new(nil).resource_object
        end
      end
    end
  end
end

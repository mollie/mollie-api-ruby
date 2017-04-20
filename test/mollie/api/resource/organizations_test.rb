require 'helper'

module Mollie
  module API
    module Resource
      class OrganizationsTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Organization, Organizations.new(nil).resource_object
        end
      end
    end
  end
end

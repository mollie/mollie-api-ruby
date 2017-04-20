require 'helper'

module Mollie
  module API
    module Resource
      class ProfilesTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Profile, Profiles.new(nil).resource_object
        end
      end
    end
  end
end

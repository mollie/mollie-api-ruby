require 'helper'

module Mollie
  module API
    module Resource
      class Profiles
        class ApiKeysTest < Test::Unit::TestCase
          def test_resource_object
            assert_equal Object::Profile::ApiKey, ApiKeys.new(nil).resource_object
          end

          def test_resource_name_and_with
            api_keys = ApiKeys.new(nil).with("profile-id")
            assert_equal "profiles/profile-id/apikeys", api_keys.resource_name

            api_keys = ApiKeys.new(nil).with(Object::Profile.new(id: "profile-id"))
            assert_equal "profiles/profile-id/apikeys", api_keys.resource_name
          end
        end
      end
    end
  end
end

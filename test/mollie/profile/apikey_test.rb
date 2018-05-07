require 'helper'

module Mollie
  class Profile
    class ApiKeyTest < Test::Unit::TestCase
      def test_setting_attributes
        attributes = {
          id:               "live",
          key:              "live_eSf9fQRwpsdfPY8y3tUFFmqjADRKyA",
          created_at: "2017-04-20T12:19:48.0Z"
        }

        api_key = ApiKey.new(attributes)

        assert_equal Mollie::Client::MODE_LIVE, api_key.id
        assert_equal "live_eSf9fQRwpsdfPY8y3tUFFmqjADRKyA", api_key.key
        assert_equal Time.parse("2017-04-20T12:19:48.0Z"), api_key.created_at
      end

      def test_testmode
        assert ApiKey.new(id: Mollie::Client::MODE_TEST).testmode?
        assert !ApiKey.new(id: 'not-test').testmode?
      end

      def test_livemode
        assert ApiKey.new(id: Mollie::Client::MODE_LIVE).livemode?
        assert !ApiKey.new(id: 'not-live').livemode?
      end
    end
  end
end

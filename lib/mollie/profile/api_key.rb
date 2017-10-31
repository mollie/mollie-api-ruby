module Mollie
  class Profile
    class ApiKey < Base
      attr_accessor :id, :key, :created_datetime

      def testmode?
        id == Mollie::API::Client::MODE_TEST
      end

      def livemode?
        id == Mollie::API::Client::MODE_LIVE
      end

      def created_datetime=(created_datetime)
        @created_datetime = Time.parse(created_datetime)
      end
    end
  end
end

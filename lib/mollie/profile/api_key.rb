module Mollie
  class Profile
    class ApiKey < Base
      attr_accessor :id, :key, :created_at

      def testmode?
        id == Mollie::Client::MODE_TEST
      end

      def livemode?
        id == Mollie::Client::MODE_LIVE
      end

      def created_at=(created_at)
        @created_at = Time.parse(created_at)
      end
    end
  end
end

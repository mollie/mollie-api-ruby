module Mollie
  module API
    module Object
      class Payment
        class Customer < Base
          attr_accessor :resource,
                  :id,
                  :name,
                  :email,
                  :locale,
                  :metadata,
                  :recentlyUsedMethods,
                  :createdDatetime
        end
      end
    end
  end
end

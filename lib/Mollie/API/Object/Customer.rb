module Mollie
  module API
    module Object
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

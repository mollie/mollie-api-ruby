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
                      :recently_used_methods,
                      :created_datetime
      end
    end
  end
end

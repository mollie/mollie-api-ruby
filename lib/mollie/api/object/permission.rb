module Mollie
  module API
    module Object
      class Permission < Base
        attr_accessor :id,
                      :description,
                      :warning,
                      :granted
      end
    end
  end
end

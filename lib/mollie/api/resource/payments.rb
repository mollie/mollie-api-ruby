module Mollie
  module API
    module Resource
      class Payments < Base
        def resource_object
          Object::Payment
        end
      end
    end
  end
end

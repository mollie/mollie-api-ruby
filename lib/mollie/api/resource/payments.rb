module Mollie
  module API
    module Resource
      class Payments < Base
        def resource_object
          Mollie::API::Object::Payment
        end
      end
    end
  end
end

module Mollie
  module API
    module Resource
      class Methods < Base
        def resource_object
          Mollie::API::Object::Method
        end
      end
    end
  end
end

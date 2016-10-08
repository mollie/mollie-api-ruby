module Mollie
  module API
    module Resource
      class Customers < Base
        def resource_object
          Object::Customer
        end
      end
    end
  end
end

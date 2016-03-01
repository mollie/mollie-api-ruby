module Mollie
  module API
    module Resource
      class Customers < Base
        def getResourceObject
          Mollie::API::Object::Customer
        end
      end
    end
  end
end

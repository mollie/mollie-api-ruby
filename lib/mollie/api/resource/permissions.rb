module Mollie
  module API
    module Resource
      class Permissions < Base
        def resource_object
          Object::Permission
        end
      end
    end
  end
end

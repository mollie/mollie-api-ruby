module Mollie
  module API
    module Resource
      class Organizations < Base
        def resource_object
          Object::Organization
        end
      end
    end
  end
end

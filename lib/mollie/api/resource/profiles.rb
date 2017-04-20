module Mollie
  module API
    module Resource
      class Profiles < Base
        def resource_object
          Object::Profile
        end
      end
    end
  end
end

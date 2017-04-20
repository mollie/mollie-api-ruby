module Mollie
  module API
    module Resource
      class Settlements < Base
        def resource_object
          Object::Settlement
        end
      end
    end
  end
end

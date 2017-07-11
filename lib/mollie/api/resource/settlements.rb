module Mollie
  module API
    module Resource
      class Settlements < Base
        def resource_object
          Object::Settlement
        end

        def next(options = {})
          get("next", options)
        end

        def open(options = {})
          get("open", options)
        end
      end
    end
  end
end

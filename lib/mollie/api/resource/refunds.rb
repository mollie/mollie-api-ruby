module Mollie
  module API
    module Resource
      class Refunds < Base
        def resource_object
          Object::Payment::Refund
        end
      end
    end
  end
end

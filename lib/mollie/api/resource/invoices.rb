module Mollie
  module API
    module Resource
      class Invoices < Base
        def resource_object
          Object::Invoice
        end
      end
    end
  end
end

module Mollie
  module API
    module Resource
      class Issuers < Base
        def resource_object
          Mollie::API::Object::Issuer
        end
      end
    end
  end
end

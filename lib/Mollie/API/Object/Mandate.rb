module Mollie
  module API
    module Object
      class Mandate < Base
        STATUS_VALID   = "valid"
        STATUS_INVALID = "invalid"

        attr_accessor :resource,
                      :id,
                      :status,
                      :method,
                      :customerId,
                      :details,
                      :createdDatetime

        def valid?
          @status == STATUS_VALID
        end
      end
    end
  end
end

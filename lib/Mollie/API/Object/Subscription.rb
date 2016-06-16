module Mollie
  module API
    module Object
      class Subscription < Base
        STATUS_ACTIVE    = "active"
        STATUS_PENDING   = "pending"   # Waiting for a valid mandate.
        STATUS_CANCELLED = "cancelled"
        STATUS_SUSPENDED = "suspended" # Active, but mandate became invalid.
        STATUS_COMPLETED = "completed"

        attr_accessor :resource,
                      :id,
                      :customerId,
                      :mode,
                      :createdDatetime,
                      :status,
                      :amount,
                      :times,
                      :interval,
                      :description,
                      :method,
                      :cancelledDatetime
      end
    end
  end
end

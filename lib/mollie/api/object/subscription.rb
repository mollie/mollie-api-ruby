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
                      :customer_id,
                      :mode,
                      :created_datetime,
                      :status,
                      :amount,
                      :times,
                      :interval,
                      :description,
                      :method,
                      :cancelled_datetime
      end
    end
  end
end

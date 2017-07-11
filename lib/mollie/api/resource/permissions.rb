module Mollie
  module API
    module Resource
      class Permissions < Base
        def self.available
          %w(
                  payments.read
                  payments.write
                  refunds.read
                  refunds.write
                  customers.read
                  customers.write
                  mandates.read
                  mandates.write
                  subscriptions.read
                  subscriptions.write
                  profiles.read
                  profiles.write
                  invoices.read
                  settlements.read
                  organizations.read
                  organizations.write)
        end

        def resource_object
          Object::Permission
        end
      end
    end
  end
end

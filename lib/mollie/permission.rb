module Mollie
  class Permission < Base
    AVAILABLE = %w(
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

    attr_accessor :id,
                  :description,
                  :warning,
                  :granted
  end
end

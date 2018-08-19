module Mollie
  class Permission < Base
    AVAILABLE = %w[
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
      organizations.write
    ].freeze

    attr_accessor :id,
                  :description,
                  :granted
  end
end

module Mollie
  class Customer < Base
    attr_accessor :id,
                  :mode,
                  :name,
                  :email,
                  :locale,
                  :metadata,
                  :created_at

    def created_at=(created_at)
      @created_at = Time.parse(created_at.to_s)
    end

    def metadata=(metadata)
      @metadata = OpenStruct.new(metadata) if metadata.is_a?(Hash)
    end

    def mandates(options = {})
      Mandate.all(options.merge(customer_id: id))
    end

    def payments(options = {})
      Payment.all(options.merge(customer_id: id))
    end

    def subscriptions(options = {})
      Subscription.all(options.merge(customer_id: id))
    end
  end
end

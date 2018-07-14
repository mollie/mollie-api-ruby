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

    def payments
      Relation.new(self, Customer::Payment)
    end

    def mandates
      Relation.new(self, Customer::Mandate)
    end

    def subscriptions
      Relation.new(self, Customer::Subscription)
    end
  end
end

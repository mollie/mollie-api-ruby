module Mollie
  class Settlement < Base
    attr_accessor :id,
                  :reference,
                  :settled_datetime,
                  :amount,
                  :periods,
                  :payment_ids,
                  :refund_ids,
                  :links

    def self.open(options = {})
      get("open", options)
    end

    def self.next(options = {})
      get("next", options)
    end

    def settled_datetime=(settled_datetime)
      @settled_datetime = Time.parse(settled_datetime.to_s) rescue nil
    end

    def amount=(amount)
      @amount = BigDecimal.new(amount.to_s) if amount
    end

    def periods=(periods)
      @periods = Util.nested_openstruct(periods) if periods.is_a?(Hash)
    end

    def payments
      links && links['payments']
    end
  end
end

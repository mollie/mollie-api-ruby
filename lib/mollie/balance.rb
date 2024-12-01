module Mollie
  class Balance < Base
    attr_accessor :id,
                  :mode,
                  :currency,
                  :description,
                  :status,
                  :transfer_frequency,
                  :transfer_reference,
                  :_links

    attr_reader :transfer_threshold,
                :transfer_destination,
                :available_amount,
                :pending_amount,
                :created_at

    alias links _links

    def self.primary(options = {})
      get('primary', options)
    end

    def transfer_threshold=(amount)
      @transfer_threshold = Mollie::Amount.new(amount)
    end

    def transfer_destination=(transfer_destination)
      @transfer_destination = OpenStruct.new(transfer_destination) if transfer_destination.is_a?(Hash)
    end

    def available_amount=(amount)
      @available_amount = Mollie::Amount.new(amount)
    end

    def pending_amount=(amount)
      @pending_amount = Mollie::Amount.new(amount)
    end

    def created_at=(created_at)
      @created_at = Time.parse(created_at.to_s)
    end

    def report(options = {})
      response = Client.instance.perform_http_call("GET", "balances/#{id}", "report", {}, options)
      Balance::Report.new(response)
    end

    def transactions(options = {})
      Balance::Transaction.all(options.merge(balance_id: id))
    end
  end
end

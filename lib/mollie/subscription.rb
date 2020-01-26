module Mollie
  class Subscription < Base
    STATUS_ACTIVE    = 'active'.freeze
    STATUS_PENDING   = 'pending'.freeze # Waiting for a valid mandate.
    STATUS_CANCELED  = 'canceled'.freeze
    STATUS_SUSPENDED = 'suspended'.freeze # Active, but mandate became invalid.
    STATUS_COMPLETED = 'completed'.freeze

    attr_accessor :id,
                  :customer_id,
                  :mode,
                  :created_at,
                  :status,
                  :amount,
                  :times,
                  :times_remaining,
                  :interval,
                  :next_payment_date,
                  :description,
                  :method,
                  :mandate_id,
                  :canceled_at,
                  :webhook_url,
                  :metadata,
                  :application_fee,
                  :_links

    alias links _links

    def active?
      status == STATUS_ACTIVE
    end

    def pending?
      status == STATUS_PENDING
    end

    def suspended?
      status == STATUS_SUSPENDED
    end

    def canceled?
      status == STATUS_CANCELED
    end

    def completed?
      status == STATUS_COMPLETED
    end

    def created_at=(created_at)
      @created_at = begin
                      Time.parse(created_at.to_s)
                    rescue StandardError
                      nil
                    end
    end

    def canceled_at=(canceled_at)
      @canceled_at = begin
                       Time.parse(canceled_at.to_s)
                     rescue StandardError
                       nil
                     end
    end

    def amount=(amount)
      @amount = Mollie::Amount.new(amount)
    end

    def times=(times)
      @times = times.to_i
    end

    def next_payment_date=(next_payment_date)
      @next_payment_date = begin
                             Date.parse(next_payment_date)
                           rescue StandardError
                             nil
                           end
    end

    def customer(options = {})
      Customer.get(customer_id, options)
    end

    def payments(options = {})
      resource_url = Util.extract_url(links, 'payments')
      return if resource_url.nil?
      response = Mollie::Client.instance.perform_http_call('GET', resource_url, nil, {}, options)
      Mollie::List.new(response, Mollie::Payment)
    end

    def metadata=(metadata)
      @metadata = OpenStruct.new(metadata) if metadata.is_a?(Hash)
    end

    def application_fee=(application_fee)
      amount      = Amount.new(application_fee['amount'])
      description = application_fee['description']

      @application_fee = OpenStruct.new(
        amount: amount,
        description: description
      )
    end
  end
end

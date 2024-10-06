module Mollie
  class PaymentLink < Base
    attr_accessor :id,
      :mode,
      :description,
      :archived,
      :redirect_url,
      :webhook_url,
      :profile_id,
      :_links

    attr_reader :amount,
      :created_at,
      :paid_at,
      :updated_at,
      :expires_at

    alias_method :links, :_links

    def self.embedded_resource_name(_parent_id = nil)
      "payment_links"
    end

    def self.resource_name(_parent_id = nil)
      "payment-links"
    end

    def amount=(amount)
      @amount = Mollie::Amount.new(amount)
    end

    def archived?
      archived
    end

    def created_at=(created_at)
      @created_at = Time.parse(created_at.to_s)
    end

    def paid_at=(paid_at)
      @paid_at = Time.parse(paid_at.to_s)
    rescue
      nil
    end

    def updated_at=(updated_at)
      @updated_at = Time.parse(updated_at.to_s)
    rescue
      nil
    end

    def expires_at=(expires_at)
      @expires_at = Time.parse(expires_at.to_s)
    rescue
      nil
    end

    def payment_link
      Util.extract_url(links, "payment_link")
    end

    def payments(options = {})
      resource_url = Util.extract_url(links, "self")
      payments_url = File.join(resource_url, "/payments")

      response = Mollie::Client.instance.perform_http_call("GET", payments_url, nil, {}, options)
      Mollie::List.new(response, Mollie::Payment)
    end
  end
end

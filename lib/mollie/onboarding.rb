module Mollie
  class Onboarding < Base
    attr_accessor :name,
                  :signed_up_at,
                  :status,
                  :can_receive_payments,
                  :can_receive_settlements,
                  :_links

    alias links _links

    def self.me(options = {})
      response = Client.instance.perform_http_call('GET', 'onboarding', 'me', {}, options)
      new(response)
    end

    def self.submit(data = {}, options = {})
      Client.instance.perform_http_call('POST', 'onboarding', 'me', data, options)
      nil
    end

    def dashboard
      Util.extract_url(links, 'onboarding')
    end

    def organization(options = {})
      resource_url = Util.extract_url(links, 'organization')
      response = Client.instance.perform_http_call('GET', resource_url, nil, {}, options)
      Organization.new(response)
    end

    def signed_up_at=(signed_up_at)
      @signed_up_at = Time.parse(signed_up_at.to_s)
    end
  end
end

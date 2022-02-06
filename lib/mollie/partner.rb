module Mollie
  class Partner < Base
    attr_accessor :partner_type,
                  :is_commission_partner,
                  :partner_contract_signed_at,
                  :partner_contract_update_available,
                  :_links

    attr_reader :user_agent_tokens

    alias links _links

    def self.current(options = {})
      response = Client.instance.perform_http_call('GET', 'organizations/me/partner', nil, {}, options)
      new(response)
    end

    def type
      partner_type
    end

    def commission_partner?
      is_commission_partner
    end

    def contract_signed_at
      @contract_signed_at = begin
        Time.parse(partner_contract_signed_at)
      rescue StandardError
        nil
      end
    end

    def contract_update_available?
      partner_contract_update_available
    end

    def user_agent_tokens=(tokens)
      @user_agent_tokens = tokens.map do |token|
        OpenStruct.new(
          token: token['token'],
          starts_at: Time.parse(token['starts_at']),
          ends_at: (Time.parse(token['ends_at']) unless token['ends_at'].nil?)
        )
      end
    end

    def signuplink
      Util.extract_url(links, 'signuplink')
    end
  end
end

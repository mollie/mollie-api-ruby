require 'helper'

module Mollie
  class PartnerTest < Test::Unit::TestCase
    def setup
      stub_request(:get, 'https://api.mollie.com/v2/organizations/me/partner')
        .to_return(status: 200, body: read_fixture('organizations/partner.json'), headers: {})
    end

    def test_class_type
      partner = Partner.current
      assert_equal Mollie::Partner, partner.class
    end

    def test_partner_type
      partner = Partner.current
      assert_equal 'signuplink', partner.type
    end

    def test_commision_partner
      partner = Partner.current
      assert partner.commission_partner?
    end

    def test_contract_signed_at
      partner = Partner.current
      assert_equal Time.parse('2018-03-20T13:13:37+00:00'), partner.contract_signed_at
    end

    def test_contract_update_available?
      partner = Partner.current
      assert partner.contract_update_available?
    end

    def test_signuplink
      partner = Partner.current
      assert_equal 'https://www.mollie.com/dashboard/signup/myCode?lang=en', partner.signuplink
    end

    def test_user_agent_tokens
      token = Partner.current.user_agent_tokens.first
      assert_equal 'unique-token', token.token
      assert_equal Time.parse('2018-03-20T13:13:37+00:00'), token.starts_at
      assert_nil nil, token.ends_at
    end
  end
end

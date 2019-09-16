require 'helper'

module Mollie
  class OnboardingTest < Test::Unit::TestCase
    def test_get_onboarding
      stub_request(:get, 'https://api.mollie.com/v2/onboarding/me')
        .to_return(status: 200, body: read_fixture('onboarding/me.json'), headers: {})

      onboarding = Onboarding.me
      assert_equal 'Mollie B.V.', onboarding.name
      assert_equal 'completed', onboarding.status
      assert_equal true, onboarding.can_receive_payments
      assert_equal true, onboarding.can_receive_settlements
      assert_equal Time.parse('2018-12-20T10:49:08+00:00'), onboarding.signed_up_at
      assert_equal 'https://www.mollie.com/dashboard/onboarding', onboarding.dashboard
    end

    def test_submit_onboarding_data
      minified_body = JSON.parse(read_fixture('onboarding/submit.json')).to_json

      stub_request(:post, 'https://api.mollie.com/v2/onboarding/me')
        .with(body: minified_body).to_return(status: 204)

      assert_nil Onboarding.submit(
        organization: {
          name: "Mollie B.V.",
          address: {
             streetAndNumber: "Keizersgracht 313",
             postalCode: "1018 EE",
             city: "Amsterdam",
             country: "NL"
          },
          registrationNumber: "30204462",
          vatNumber: "NL815839091B01"
        },
        profile: {
          name: "Mollie",
          url: "https://www.mollie.com",
          email: "info@mollie.com",
          phone: "+31208202070",
          categoryCode: 6012
        }
      )
    end

    def test_get_organization
      stub_request(:get, 'https://api.mollie.com/v2/onboarding/me')
        .to_return(status: 200, body: read_fixture('onboarding/me.json'), headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/organization/org_12345')
        .to_return(status: 200, body: %({"id": "org_12345"}), headers: {})

      onboarding = Onboarding.me
      organization = onboarding.organization

      assert_equal 'org_12345', organization.id
    end
  end
end

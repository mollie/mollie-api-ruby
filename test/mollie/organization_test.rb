require 'helper'

module Mollie
  class OrganizationTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:                  'org_1234567',
        name:                'Mollie B.V.',
        email:               'info@mollie.com',
        address:             { "street_and_number"  => 'Keizersgracht 313' },
        postal_code:         '1016EE',
        city:                'Amsterdam',
        country:             'Netherlands',
        country_code:        'NL',
        registration_number: '30204462',
        verified_at:         '2007-06-29T09:41:00.0Z'
      }

      organization = Organization.new(attributes)

      assert_equal 'org_1234567', organization.id
      assert_equal 'Mollie B.V.', organization.name
      assert_equal 'info@mollie.com', organization.email
      assert_equal 'Keizersgracht 313', organization.address.street_and_number
      assert_equal '1016EE', organization.postal_code
      assert_equal 'Amsterdam', organization.city
      assert_equal 'NL', organization.country_code
      assert_equal '30204462', organization.registration_number
      assert_equal Time.parse('2007-06-29T09:41:00.0Z'), organization.verified_at
    end

    def test_verified_at_optional
      assert_equal nil, Organization.new(verified_at: nil).verified_at
    end
  end
end

require 'helper'

module Mollie
  class OrganizationTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:                  'org_1234567',
        name:                'Mollie B.V.',
        email:               'info@mollie.com',
        address: {
          street_and_number: "Keizersgracht 313",
          postal_code:       "1016 EE",
          city:              "Amsterdam",
          country:           "NL"
        },
        registration_number: '30204462',
        vat_number:          'NL815839091B01',
      }

      organization = Organization.new(attributes)

      assert_equal 'org_1234567', organization.id
      assert_equal 'Mollie B.V.', organization.name
      assert_equal 'info@mollie.com', organization.email
      assert_equal 'Keizersgracht 313', organization.address.street_and_number
      assert_equal '1016 EE', organization.address.postal_code
      assert_equal 'Amsterdam', organization.address.city
      assert_equal 'NL', organization.address.country
      assert_equal '30204462', organization.registration_number
      assert_equal 'NL815839091B01', organization.vat_number
    end
  end
end

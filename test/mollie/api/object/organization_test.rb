require 'helper'

module Mollie
  module API
    module Object
      class OrganizationTest < Test::Unit::TestCase
        def test_setting_attributes
          attributes = {
              id:                    'org_1234567',
              name:                  'Mollie B.V.',
              email:                 'info@mollie.com',
              address:               'Keizersgracht 313',
              postal_code:           '1016EE',
              city:                  'Amsterdam',
              country:               'Netherlands',
              country_code:          'NL',
              registration_type:     'bv',
              registration_number:   '30204462',
              registration_datetime: '2004-04-01T09:41:00.0Z',
              verified_datetime:     '2007-06-29T09:41:00.0Z'
          }

          organization = Organization.new(attributes)

          assert_equal 'org_1234567', organization.id
          assert_equal 'Mollie B.V.', organization.name
          assert_equal 'info@mollie.com', organization.email
          assert_equal 'Keizersgracht 313', organization.address
          assert_equal '1016EE', organization.postal_code
          assert_equal 'Amsterdam', organization.city
          assert_equal 'Netherlands', organization.country
          assert_equal 'NL', organization.country_code
          assert_equal 'bv', organization.registration_type
          assert_equal '30204462', organization.registration_number
          assert_equal Time.parse('2004-04-01T09:41:00.0Z'), organization.registration_datetime
          assert_equal Time.parse('2007-06-29T09:41:00.0Z'), organization.verified_datetime
        end

        def test_verified_datetime_optional
          assert_equal nil, Organization.new(verified_datetime: nil).verified_datetime
        end
      end
    end
  end
end

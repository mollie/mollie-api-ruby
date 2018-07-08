require 'helper'

module Mollie
  class ProfileTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:               'pfl_v9hTwCvYqw',
        mode:             'live',
        name:             'My website name',
        website:          'https://www.mywebsite.com',
        email:            'info@mywebsite.com',
        phone:            '+31208202070',
        category_code:    5399,
        status:           'unverified',
        review: {
          status: 'pending'
        },
        created_at: '2017-04-20T09:03:58.0Z',
        _links: {
          "self" => {
            "href" => "https://api.mollie.com/v2/profiles/pfl_v9hTwCvYqw",
            "type" => "application/hal+json"
          },
          "chargebacks" => {
            "href" => "https://api.mollie.com/v2/chargebacks?profileId=pfl_v9hTwCvYqw",
            "type" => "application/hal+json"
          },
          "methods" => {
            "href" => "https://api.mollie.com/v2/methods?profileId=pfl_v9hTwCvYqw",
            "type" => "application/hal+json"
          },
          "payments" => {
            "href" => "https://api.mollie.com/v2/payments?profileId=pfl_v9hTwCvYqw",
            "type" => "application/hal+json"
          },
          "refunds" => {
            "href" => "https://api.mollie.com/v2/refunds?profileId=pfl_v9hTwCvYqw",
            "type" => "application/hal+json"
          },
          "checkout_preview_url" => {
            "href" => "https://www.mollie.com/payscreen/preview/pfl_v9hTwCvYqw",
            "type" => "text/html"
          },
          "documentation" => {
            "href" => "https://docs.mollie.com/reference/v2/profiles-api/create-profile",
            "type" => "text/html"
          }
        }
      }

      profile = Profile.new(attributes)

      assert_equal 'pfl_v9hTwCvYqw', profile.id
      assert_equal 'live', profile.mode
      assert_equal 'My website name', profile.name
      assert_equal 'https://www.mywebsite.com', profile.website
      assert_equal 'info@mywebsite.com', profile.email
      assert_equal '+31208202070', profile.phone
      assert_equal 5399, profile.category_code
      assert_equal Profile::STATUS_UNVERIFIED, profile.status
      assert_equal Profile::REVIEW_STATUS_PENDING, profile.review.status
      assert_equal Time.parse('2017-04-20T09:03:58.0Z'), profile.created_at
      assert_equal 'https://www.mollie.com/payscreen/preview/pfl_v9hTwCvYqw', profile.checkout_preview_url
    end

    def test_status_unverified
      assert Profile.new(status: Profile::STATUS_UNVERIFIED).unverified?
      assert !Profile.new(status: 'not-unverified').unverified?
    end

    def test_status_verified
      assert Profile.new(status: Profile::STATUS_VERIFIED).verified?
      assert !Profile.new(status: 'not-verified').verified?
    end

    def test_status_blocked
      assert Profile.new(status: Profile::STATUS_BLOCKED).blocked?
      assert !Profile.new(status: 'not-blocked').blocked?
    end

    def test_review_status_pending
      assert Profile.new(review: { status: Profile::REVIEW_STATUS_PENDING }).review_pending?
      assert !Profile.new(review: { status: 'not-pending' }).review_pending?
    end

    def test_review_status_rejected
      assert Profile.new(review: { status: Profile::REVIEW_STATUS_REJECTED }).review_rejected?
      assert !Profile.new(review: { status: 'not-rejected' }).review_rejected?
    end
  end
end

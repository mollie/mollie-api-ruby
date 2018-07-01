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
        phone:            '31123456789',
        category_code:    5399,
        status:           'unverified',
        review:           {
          status: 'pending'
        },
        created_at: '2017-04-20T09:03:58.0Z',
        updated_at: '2017-04-20T09:03:58.0Z',
        links:            {
          'apikeys'              => 'https://api.mollie.nl/v2/profiles/pfl_v9hTwCvYqw/apikeys',
          'checkout_preview_url' => 'https://www.mollie.com/beheer/account_profielen/preview-payscreen/1337',
        }
      }

      profile = Profile.new(attributes)

      assert_equal 'pfl_v9hTwCvYqw', profile.id
      assert_equal 'live', profile.mode
      assert_equal 'My website name', profile.name
      assert_equal 'https://www.mywebsite.com', profile.website
      assert_equal 'info@mywebsite.com', profile.email
      assert_equal '31123456789', profile.phone
      assert_equal 5399, profile.category_code
      assert_equal Profile::STATUS_UNVERIFIED, profile.status
      assert_equal Profile::REVIEW_STATUS_PENDING, profile.review.status
      assert_equal Time.parse('2017-04-20T09:03:58.0Z'), profile.created_at
      assert_equal Time.parse('2017-04-20T09:03:58.0Z'), profile.updated_at
      assert_equal 'https://api.mollie.nl/v2/profiles/pfl_v9hTwCvYqw/apikeys', profile.apikeys_url
      assert_equal 'https://www.mollie.com/beheer/account_profielen/preview-payscreen/1337', profile.checkout_preview_url
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

    def test_list_apikeys
      stub_request(:get, "https://api.mollie.nl/v2/profiles/pfl-id/apikeys")
        .to_return(:status => 200, :body => %{{"_embedded" : {"apikeys": [{"id":"live", "key":"key"}]}}}, :headers => {})

      apikeys = Profile.new(id: "pfl-id").apikeys.all

      assert_equal "live", apikeys.first.id
      assert_equal "key", apikeys.first.key
    end

    def test_update_apikey
      stub_request(:post, "https://api.mollie.nl/v2/profiles/pfl-id/apikeys/live")
        .to_return(:status => 200, :body => %{{"id":"live", "key":"key"}}, :headers => {})

      apikey = Profile.new(id: "pfl-id").apikeys.update("live")

      assert_equal "live", apikey.id
      assert_equal "key", apikey.key
    end

    def test_get_apikey
      stub_request(:get, "https://api.mollie.nl/v2/profiles/pfl-id/apikeys/live")
        .to_return(:status => 200, :body => %{{"id":"live", "key":"key"}}, :headers => {})

      apikey = Profile.new(id: "pfl-id").apikeys.get("live")

      assert_equal "live", apikey.id
      assert_equal "key", apikey.key
    end
  end
end

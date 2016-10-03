require 'test/unit'
require 'webmock/test_unit'

module Test::Unit
  class TestEmpty < TestCase
    def test_success
      assert_true(true)
    end

    def test_mock
      stub_request(:any, "www.example.com")
      Net::HTTP.get("www.example.com", "/")
    end
  end
end

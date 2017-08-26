require 'helper'

module Mollie
  class TestObject < Base
    attr_accessor :id, :amount, :my_field
  end

  class BaseTest < Test::Unit::TestCase
    def test_resource_name
      assert_equal "testobject", TestObject.resource_name
    end

    def test_setting_attributes
      attributes = { my_field: "my value", extra_field: "extra" }
      object     = TestObject.new(attributes)

      assert_equal "my value", object.my_field
      assert_equal attributes, object.attributes
    end

    def test_get
      stub_request(:get, "https://api.mollie.nl/v1/testobject/my-id")
        .to_return(:status => 200, :body => %{{"id":"my-id"}}, :headers => {})

      resource = TestObject.get("my-id")

      assert_equal "my-id", resource.id
    end

    def test_create
      stub_request(:post, "https://api.mollie.nl/v1/testobject")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "amount":1.00}}, :headers => {})

      resource = TestObject.create(amount: 1.95)

      assert_equal "my-id", resource.id
      assert_equal BigDecimal.new("1.00"), resource.amount
    end

    def test_update
      stub_request(:post, "https://api.mollie.nl/v1/testobject/my-id")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "amount":1.00}}, :headers => {})

      resource = TestObject.update("my-id", amount: 1.95)

      assert_equal "my-id", resource.id
      assert_equal BigDecimal.new("1.00"), resource.amount
    end

    def test_delete
      stub_request(:delete, "https://api.mollie.nl/v1/testobject/my-id")
        .to_return(:status => 204, :headers => {})

      resource = TestObject.delete("my-id")

      assert_equal nil, resource
    end

    def test_all
      stub_request(:get, "https://api.mollie.nl/v1/testobject?count=50&offset=0")
        .to_return(:status => 200, :body => %{{"data":[{"id":"my-id"}]}}, :headers => {})

      resource = TestObject.all

      assert_equal "my-id", resource.first.id
    end
  end
end

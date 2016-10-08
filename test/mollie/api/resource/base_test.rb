require 'helper'

module Mollie
  module API
    module Resource
      class TestObject < Object::Base
        attr_accessor :id, :amount
      end

      class TestResource < Base
        def resource_object
          TestObject
        end
      end

      class BaseTest < Test::Unit::TestCase
        def test_resource_name
          test_resource = TestResource.new(nil)
          assert_equal "testresource", test_resource.resource_name
        end

        def test_get
          stub_request(:get, "https://api.mollie.nl/v1/testresource/my-id")
              .to_return(:status => 200, :body => %{{"id":"my-id"}}, :headers => {})

          client        = Client.new("test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM")
          test_resource = TestResource.new(client)
          resource = test_resource.get("my-id")

          assert_equal "my-id", resource.id
        end

        def test_create
          stub_request(:post, "https://api.mollie.nl/v1/testresource")
              .with(body: %{{"amount":1.95}})
              .to_return(:status => 201, :body => %{{"id":"my-id", "amount":1.00}}, :headers => {})

          client        = Client.new("test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM")
          test_resource = TestResource.new(client)
          resource = test_resource.create(amount: 1.95)

          assert_equal "my-id", resource.id
          assert_equal BigDecimal.new("1.00"), resource.amount
        end

        def test_update
          stub_request(:post, "https://api.mollie.nl/v1/testresource/my-id")
              .with(body: %{{"amount":1.95}})
              .to_return(:status => 201, :body => %{{"id":"my-id", "amount":1.00}}, :headers => {})

          client        = Client.new("test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM")
          test_resource = TestResource.new(client)
          resource = test_resource.update("my-id", amount: 1.95)

          assert_equal "my-id", resource.id
          assert_equal BigDecimal.new("1.00"), resource.amount
        end

        def test_delete
          stub_request(:delete, "https://api.mollie.nl/v1/testresource/my-id")
              .to_return(:status => 204, :headers => {})

          client        = Client.new("test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM")
          test_resource = TestResource.new(client)
          resource = test_resource.delete("my-id")

          assert_equal nil, resource
        end

        def test_all
          stub_request(:get, "https://api.mollie.nl/v1/testresource")
              .to_return(:status => 200, :body => %{{"data":[{"id":"my-id"}]}}, :headers => {})

          client        = Client.new("test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM")
          test_resource = TestResource.new(client)
          resource = test_resource.all

          assert_equal "my-id", resource.first.id
        end
      end
    end
  end
end

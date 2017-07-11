module Mollie
  module API
    module Resource
      class Base
        def initialize(client)
          @client = client
        end

        def resource_name
          self.class.name.downcase.split("::").slice(3..-1).join "/"
        end

        def create(data = {})
          request("POST", nil, data) { |response|
            new_resource_object response
          }
        end

        def get(id, options = {})
          request("GET", id, {}, options) { |response|
            new_resource_object response
          }
        end

        def update(id, data = {})
          request("POST", id, data) { |response|
            new_resource_object response
          }
        end

        def delete(id, options = {})
          request "DELETE", id, options
        end

        def all(offset = 0, limit = 50, options = {})
          request("GET", nil, {}, { offset: offset, count: limit }.merge(options)) { |response|
            Object::List.new response, resource_object
          }
        end

        def new_resource_object(response)
          resource_object.new response
        end

        def request(method, id = 0, data = {}, query = {})
          response = @client.perform_http_call method, resource_name, id, data, query

          yield(response) if block_given?
        end
      end
    end
  end
end

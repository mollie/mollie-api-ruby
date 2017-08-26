module Mollie
  class Base
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
      attributes.each do |key, value|
        public_send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    class << self
      def create(data = {})
        request("POST", nil, data) do |response|
          new(response)
        end
      end

      def all(offset = 0, limit = 50, options = {})
        request("GET", nil, {}, { offset: offset, count: limit }.merge(options)) do |response|
          Mollie::List.new(response, self)
        end
      end

      def get(id, options = {})
        request("GET", id, {}, options) do |response|
          new(response)
        end
      end

      def update(id, data = {})
        request("POST", id, data) do |response|
          new(response)
        end
      end

      def delete(id, options = {})
        request("DELETE", id, options)
      end

      def request(method, id = 0, data = {}, query = {})
        response = Mollie::Client.instance.perform_http_call(method, resource_name, id, data, query)
        yield(response) if block_given?
      end

      def resource_name
        name.downcase.split("::").slice(1..-1).join "/"
      end
    end

    def update(data = {})
      self.class.update(id, data)
    end

    def delete(options = {})
      self.class.delete(id, options)
    end
  end
end

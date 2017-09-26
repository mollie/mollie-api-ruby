module Mollie
  class Base
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
      assign_attributes(attributes)
    end

    def assign_attributes(attributes)
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

      def all(*args)
        options       = args.last.is_a?(Hash) ? args.pop : {}
        offset, limit = args
        request("GET", nil, {}, { offset: offset || 0, count: limit || 50 }.merge(options)) do |response|
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
        parent_id = query.delete(self.parent_id) || data.delete(self.parent_id)
        response  = Mollie::Client.instance.perform_http_call(method, resource_name(parent_id), id, data, query)
        yield(response) if block_given?
      end

      def id_param
        "#{name.downcase.split("::")[-1]}_id".to_sym
      end

      def parent_id
        "#{name.downcase.split("::")[-2]}_id".to_sym
      end

      def resource_name(parent_id = nil)
        path = name.downcase.split("::").slice(1..-1).map(&Util.method(:pluralize))

        if path.size == 2 && parent_id
          path.join("/#{parent_id}/")
        else
          path.last
        end
      end
    end

    def update(data = {})
      if (parent_id = attributes[self.class.parent_id])
        data[self.class.parent_id] = parent_id
      end

      if (resource = self.class.update(id, data))
        !!assign_attributes(resource.attributes)
      else
        resource
      end
    end

    def delete(options = {})
      if (parent_id = attributes[self.class.parent_id])
        options[self.class.parent_id] = parent_id
      end
      self.class.delete(id, options)
    end
  end
end

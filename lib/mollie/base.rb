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
      def create(data = {}, options = {})
        request('POST', nil, data, options) do |response|
          new(response)
        end
      end

      def all(options = {})
        id      = nil
        data    = {}

        request('GET', id, data, options) do |response|
          Mollie::List.new(response, self)
        end
      end

      def get(id, options = {})
        raise Mollie::Exception, "Invalid resource ID: #{id.inspect}" if id.nil? || id.strip.empty?

        request('GET', id, {}, options) do |response|
          new(response)
        end
      end

      def update(id, data = {})
        request('PATCH', id, data) do |response|
          new(response)
        end
      end

      def delete(id, options = {})
        request('DELETE', id, options)
      end
      alias cancel delete

      def request(method, id = 0, data = {}, options = {})
        parent_id = options.delete(self.parent_id) || data.delete(self.parent_id)
        response  = Mollie::Client.instance.perform_http_call(method, resource_name(parent_id), id, data, options)
        yield(response) if block_given?
      end

      def id_param
        "#{name.downcase.split('::')[-1]}_id".to_sym
      end

      def parent_id
        "#{name.downcase.split('::')[-2]}_id".to_sym
      end

      def resource_name(parent_id = nil)
        path = name.downcase.split('::').slice(1..-1).map(&Util.method(:pluralize))

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
    alias cancel delete
  end
end

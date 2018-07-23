module Mollie
  class List < Base
    include Enumerable

    attr_accessor :klass, :items, :_links
    alias_method :links, :_links

    def initialize(list_attributes, klass)
      @klass = klass

      if list_attributes['_embedded']
        list_attributes['items'] ||= list_attributes['_embedded'].fetch(klass.resource_name, [])
      else
        list_attributes['items'] ||= []
      end
      super list_attributes

      @items = self.items.map do |attributes|
        klass.new attributes
      end
    end

    def each(&block)
      @items.each(&block)
    end

    def next(options = {})
      if links['next'].nil?
        return self.class.new({}, klass)
      end

      href = URI.parse(links['next']['href'])
      query = URI.decode_www_form(href.query).to_h

      klass.all(options.merge(query))
    end

    def previous(options = {})
      if links['previous'].nil?
        return self.class.new({}, klass)
      end

      href = URI.parse(links['previous']['href'])
      query = URI.decode_www_form(href.query).to_h

      klass.all(options.merge(query))
    end
  end
end

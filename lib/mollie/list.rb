module Mollie
  class List < Base
    include Enumerable

    attr_accessor :klass, :items, :_links
    alias links _links

    def initialize(list_attributes, klass)
      @klass = klass

      list_attributes['items'] ||= if list_attributes['_embedded']
                                     list_attributes['_embedded'].fetch(klass.resource_name, [])
                                   else
                                     []
                                   end
      super list_attributes

      @items = items.map do |attributes|
        klass.new attributes
      end
    end

    def each(&block)
      @items.each(&block)
    end

    def next(options = {})
      return self.class.new({}, klass) if links['next'].nil?

      href = URI.parse(links['next']['href'])
      query = URI.decode_www_form(href.query).to_h

      klass.all(options.merge(query))
    end

    def previous(options = {})
      return self.class.new({}, klass) if links['previous'].nil?

      href = URI.parse(links['previous']['href'])
      query = URI.decode_www_form(href.query).to_h

      klass.all(options.merge(query))
    end
  end
end

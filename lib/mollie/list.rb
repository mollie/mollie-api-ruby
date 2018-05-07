module Mollie
  class List < Base
    include Enumerable

    attr_accessor :total_count,
                  :offset,
                  :count,
                  :_links,
                  :items
    alias_method :links, :_links

    def initialize(list_attributes, klass)
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

    def previous_url
      Util.extract_url(links, 'previous')
    end

    def next_url
      Util.extract_url(links, 'next')
    end
  end
end

module Mollie
  class List < Base
    include Enumerable

    attr_accessor :items, :_links
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
  end
end

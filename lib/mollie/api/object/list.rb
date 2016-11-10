module Mollie
  module API
    module Object
      class List < Base
        include Enumerable

        attr_accessor :total_count,
                      :offset,
                      :count,
                      :links,
                      :data

        def initialize(list_attributes, klass)
          list_attributes['data'] ||= []
          super list_attributes

          @data = self.data.map do |attributes|
            klass.new attributes
          end
        end

        def each(&block)
          @data.each(&block)
        end

        def first_url
          links && links['first']
        end

        def previous_url
          links && links['previous']
        end

        def next_url
          links && links['next']
        end

        def last_url
          links && links['last']
        end
      end
    end
  end
end

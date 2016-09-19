module Mollie
  module API
    module Object
      class List < Base
        include Enumerable

        attr_accessor :total_count,
                      :offset,
                      :count,
                      :data

        def initialize(hash, class_resource_object)
          data        = hash[:data] || []
          hash[:data] = nil
          super hash

          @data = []
          data.each { |hash|
            @data << (class_resource_object.new hash)
          }
        end

        def each(&block)
          @data.each { |object|
            if block_given?
              block.call object
            else
              yield object
            end
          }
        end
      end
    end
  end
end

module Mollie
  module API
    module Object
      class Base
        attr_reader :attributes

        def initialize(attributes)
          @attributes = attributes
          attributes.each do |key, value|
            if self.respond_to?("#{key}=")
              public_send("#{key}=", value)
            end
          end
        end
      end
    end
  end
end

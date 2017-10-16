module Mollie
  module API
    module Object
      class Issuer < Base
        attr_accessor :id, :name, :method, :image, :resource
      end
    end
  end
end

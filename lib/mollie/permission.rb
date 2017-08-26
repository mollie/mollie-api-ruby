module Mollie
  class Permission < Base
    attr_accessor :id,
                  :description,
                  :warning,
                  :granted
  end
end

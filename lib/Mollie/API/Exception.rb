module Mollie
  module API
    class Exception < StandardError
      @field = nil
      @code = nil

      attr_accessor :field, :code
    end
  end
end

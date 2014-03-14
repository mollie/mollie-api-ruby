module Mollie
	module API
		class Exception < StandardError
			@field = nil

			attr_accessor :field
		end
	end
end

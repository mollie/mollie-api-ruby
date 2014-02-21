module Mollie
	module API
		module Object
			class Issuer < Base
				attr_accessor :id,
				              :name,
				              :method
			end
		end
	end
end
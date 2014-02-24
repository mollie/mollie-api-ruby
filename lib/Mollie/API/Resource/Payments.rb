module Mollie
	module API
		module Resource
			class Payments < Base
				def getResourceObject ()
					Mollie::API::Object::Payment
				end
			end
		end
	end
end

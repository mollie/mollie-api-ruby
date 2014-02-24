module Mollie
	module API
		module Resource
			class Issuers < Base
				def getResourceObject ()
					Mollie::API::Object::Issuer
				end
			end
		end
	end
end

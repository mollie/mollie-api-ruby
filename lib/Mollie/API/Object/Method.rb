module Mollie
	module API
		module Object
			class Method < Base
				IDEAL        = "ideal"
				CREDITCARD   = "creditcard"
				MISTERCASH   = "mistercash"
				BANKTRANSFER = "banktransfer"
				PAYPAL       = "paypal"
				PAYSAFECARD  = "paysafecard"

				attr_accessor :id,
				              :description,
				              :amount,
				              :image

				def getMinimumAmount ()
					@amount.minimum
				end

				def getMaximumAmount ()
					@amount.maximum
				end
			end
		end
	end
end

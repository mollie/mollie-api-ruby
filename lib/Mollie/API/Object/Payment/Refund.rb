module Mollie
	module API
		module Object
			class Payment
				class Refund < Base
					attr_accessor :id,
								  :amountRefunded,
								  :amountRemaining,
								  :payment,
								  :refundedDatetime
				end
			end
		end
	end
end
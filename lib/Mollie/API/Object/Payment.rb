module Mollie
	module API
		module Object
			class Payment < Base
				STATUS_OPEN      = "open"
				STATUS_CANCELLED = "cancelled"
				STATUS_EXPIRED   = "expired"
				STATUS_PAID      = "paid"
				STATUS_PAIDOUT   = "paidout"

				attr_accessor :id,
				              :status,
				              :mode,
				              :amount,
				              :description,
				              :method,
				              :createdDatetime,
				              :paidDatetime,
				              :epiredDatetime,
				              :cancelledDatetime,
				              :metadata,
				              :details,
				              :links

				def open? ()
					@status == STATUS_OPEN
				end

				def paid? ()
					!@paidDatetime.nil?
				end

				def getPaymentUrl ()
					@links && @links.paymentUrl
				end
			end
		end
	end
end
require 'open-uri'

module Mollie
	module API
		module Resource
			class Payments
				class Refunds < Base
					@payment_id = nil

					def getResourceObject ()
						Mollie::API::Object::Payment::Refund
					end

					def getResourceName ()
						payment_id = URI::encode(@payment_id)
						"payments/#{payment_id}/refunds"
					end

					def with (payment)
						@payment_id = payment.id
						self
					end
				end
			end
		end
	end
end

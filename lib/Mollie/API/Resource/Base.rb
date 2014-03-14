module Mollie
	module API
		module Resource
			class Base
				def initialize (client)
					@client = client
				end

				def getResourceName ()
					self.class.name.downcase.split("::").slice(3..-1).join "/"
				end

				def create (data = {})
					request("POST", nil, data) { |response|
						newResourceObject response
					}
				end

				def get (id)
					request("GET", id, {}) { |response| 
						newResourceObject response
					}
				end

				def update (id, data = {})
					request("POST", id, data) { |response|
						newResourceObject response
					}
				end

				def delete (id)
					request "DELETE", id, {}
				end

				def all ()
					request("GET", nil, {}) { |response|
						Mollie::API::Object::List.new response, getResourceObject
					}
				end
				
				def newResourceObject (response)
					getResourceObject.new response
				end
				
				def request (method, id = 0, data = {})
					response = @client.performHttpCall method, getResourceName, id, data

					yield(response) if block_given?
				end
			end
		end
	end
end

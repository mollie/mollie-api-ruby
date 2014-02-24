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
					response = @client.performHttpCall "POST", getResourceName, nil, data
					getResourceObject.new response
				end

				def get (id)
					response = @client.performHttpCall "GET", getResourceName, id || 0
					getResourceObject.new response
				end

				def update (id, data = {})
					response = @client.performHttpCall "POST", getResourceName, id || 0, data
					getResourceObject.new response
				end

				def delete (id)
					@client.performHttpCall "DELETE", getResourceName, id || 0
				end

				def all ()
					response = @client.performHttpCall "GET", getResourceName
					Mollie::API::Object::List.new response, getResourceObject
				end
			end
		end
	end
end

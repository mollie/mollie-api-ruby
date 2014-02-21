module Mollie
	module API
		module Object
			class Base
				def initialize (hash)
					hash.each { |key, value|
						if value.respond_to? :each
							value = Base.new value	
						end

						instance_variable_set "@#{key}", value
						self.class.send :attr_accessor, key
					}
				end
			end
		end
	end
end

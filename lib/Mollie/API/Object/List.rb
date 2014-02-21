module Mollie
	module API
		module Object
			class List < Base
				include Enumerable  

				attr_accessor :totalCount,
				              :offset,
				              :count,
				              :data	

				def initialize (hash, classResourceObject)
					data        = hash[:data] || []
					hash[:data] = nil
					super hash

					@data = []
					data.each { |hash| 
						@data << (classResourceObject.new hash)
					}
				end

				def each (&block)
					@data.each { |object|
						if block_given?
							block.call object
						else  
							yield object
						end
					}
				end
			end
		end
	end
end
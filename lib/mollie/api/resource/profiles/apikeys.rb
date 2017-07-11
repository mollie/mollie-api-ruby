require 'open-uri'

module Mollie
  module API
    module Resource
      class Profiles
        class ApiKeys < Base
          @profile_id = nil

          def resource_object
            Object::Profile::ApiKey
          end

          def resource_name
            profile_id = URI::encode(@profile_id)
            "profiles/#{profile_id}/apikeys"
          end

          def with(profile_or_id)
            @profile_id = profile_or_id.is_a?(Object::Profile) ? profile_or_id.id : profile_or_id
            self
          end

          def create(mode)
            request("POST", mode, {}) { |response|
              new_resource_object response
            }
          end
        end
      end
    end
  end
end

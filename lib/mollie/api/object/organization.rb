module Mollie
  module API
    module Object
      class Organization < Base
        attr_accessor :id,
                      :name,
                      :email,
                      :address,
                      :postal_code,
                      :city,
                      :country,
                      :country_code,
                      :registration_type,
                      :registration_number,
                      :registration_datetime,
                      :verified_datetime

        def registration_datetime=(registration_datetime)
          @registration_datetime = Time.parse(registration_datetime.to_s) rescue nil
        end

        def verified_datetime=(verified_datetime)
          @verified_datetime = Time.parse(verified_datetime.to_s) rescue nil
        end
      end
    end
  end
end

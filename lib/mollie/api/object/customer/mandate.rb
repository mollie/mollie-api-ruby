module Mollie
  module API
    module Object
      class Customer
        class Mandate < Base
          STATUS_VALID   = "valid"
          STATUS_INVALID = "invalid"

          attr_accessor :id,
                        :status,
                        :method,
                        :customer_id,
                        :details,
                        :created_datetime,
                        :mandate_reference


          def details=(details)
            @details = OpenStruct.new(details) if details.is_a?(Hash)
          end

          def created_datetime=(created_datetime)
            @created_datetime = Time.parse(created_datetime.to_s) rescue nil
          end

          def valid?
            status == STATUS_VALID
          end

          def invalid?
            status == STATUS_INVALID
          end
        end
      end
    end
  end
end

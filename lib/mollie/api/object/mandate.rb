module Mollie
  module API
    module Object
      class Mandate < Base
        STATUS_VALID   = "valid"
        STATUS_INVALID = "invalid"

        attribute :resource,
                  :id,
                  :status,
                  :method,
                  :customer_id,
                  :details,
                  :created_datetime,
                  :mandate_reference,
                  :card_expiry_date

        def card_expiry_date=(card_expiry_date)
          @card_expiry_date = Time.parse(card_expiry_date.to_s) rescue nil
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

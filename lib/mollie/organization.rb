module Mollie
  class Organization < Base
    attr_accessor :id,
                  :name,
                  :email,
                  :address,
                  :postal_code,
                  :city,
                  :country_code,
                  :registration_number,
                  :vat_number,
                  :verified_at

    def verified_at=(verified_at)
      @verified_at = Time.parse(verified_at.to_s) rescue nil
    end

    def address=(address)
      @address = OpenStruct.new(address) if address.is_a?(Hash)
    end
  end
end

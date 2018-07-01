module Mollie
  class Organization < Base
    attr_accessor :id,
                  :name,
                  :email,
                  :address,
                  :registration_number,
                  :vat_number

    def address=(address)
      @address = OpenStruct.new(address) if address.is_a?(Hash)
    end
  end
end

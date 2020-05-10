module Mollie
  class Organization < Base
    attr_accessor :id,
                  :name,
                  :locale,
                  :email,
                  :address,
                  :registration_number,
                  :vat_number,
                  :vat_regulation,
                  :_links

    alias links _links

    def self.current(options = {})
      get('me', options)
    end

    def address=(address)
      @address = OpenStruct.new(address) if address.is_a?(Hash)
    end

    def dashboard_url
      Util.extract_url(links, 'dashboard')
    end
  end
end

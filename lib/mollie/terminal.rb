module Mollie
  class Terminal < Base

    STATUS_PENDING   = "pending".freeze
    STATUS_ACTIVE    = "active".freeze
    STATUS_INACTIVE  = "inactive".freeze

    attr_accessor :id,
                  :profile_id,
                  :status,
                  :brand,
                  :model,
                  :serial_number,
                  :currency,
                  :description,
                  :created_at,
                  :updated_at,
                  :deactivated_at,
                  :_links

    alias links _links

    def pending?
      status == STATUS_PENDING
    end

    def active?
      status == STATUS_ACTIVE
    end

    def inactive?
      status == STATUS_INACTIVE
    end

    def created_at=(created_at)
      @created_at = begin
                      Time.parse(created_at.to_s)
                    rescue StandardError
                      nil
                    end
    end

    def updated_at=(updated_at)
      @updated_at = begin
                      Time.parse(updated_at.to_s)
                    rescue StandardError
                      nil
                    end
    end

    def deactivated_at=(deactivated_at)
      @deactivated_at = begin
                          Time.parse(deactivated_at.to_s)
                        rescue StandardError
                          nil
                        end
    end
  end
end

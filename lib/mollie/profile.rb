module Mollie
  class Profile < Base
    CATEGORY_CODE_GENERAL_MERCHANDISE                = 5399
    CATEGORY_CODE_ELECTRONICS_COMPUTERS_AND_SOFTWARE = 5732
    CATEGORY_CODE_TRAVEL_RENTAL_AND_TRANSPORTATION   = 4121
    CATEGORY_CODE_FINANCIAL_SERVICES                 = 6012
    CATEGORY_CODE_FOOD_AND_DRINKS                    = 5499
    CATEGORY_CODE_EVENTS_FESTIVALS_AND_RECREATION    = 7999
    CATEGORY_CODE_BOOKS_MAGAZINES_AND_NEWSPAPERS     = 5192
    CATEGORY_CODE_PERSONAL_SERVICES                  = 7299
    CATEGORY_CODE_CHARITY_AND_DONATIONS              = 8398
    CATEGORY_CODE_OTHER                              = 0

    STATUS_UNVERIFIED = "unverified"
    STATUS_VERIFIED   = "verified"
    STATUS_BLOCKED    = "blocked"

    REVIEW_STATUS_PENDING  = "pending"
    REVIEW_STATUS_REJECTED = "rejected"

    attr_accessor :id,
                  :mode,
                  :name,
                  :website,
                  :email,
                  :phone,
                  :category_code,
                  :status,
                  :review,
                  :created_at,
                  :_links

    alias_method :links, :_links

    def unverified?
      status == STATUS_UNVERIFIED
    end

    def verified?
      status == STATUS_VERIFIED
    end

    def blocked?
      status == STATUS_BLOCKED
    end

    def review=(review)
      @review = OpenStruct.new(review) if review.is_a?(Hash)
    end

    def review_pending?
      @review && @review.status == REVIEW_STATUS_PENDING
    end

    def review_rejected?
      @review && @review.status == REVIEW_STATUS_REJECTED
    end

    def created_at=(created_at)
      @created_at = Time.parse(created_at.to_s) rescue nil
    end

    def checkout_preview_url
      Util.extract_url(links, 'checkout_preview_url')
    end

    def chargebacks(options = {})
      Chargeback.all(options.merge(profile_id: id))
    end

    def methods(options = {})
      Method.all(options.merge(profile_id: id))
    end

    def payments(options = {})
      Payment.all(options.merge(profile_id: id))
    end

    def refunds(options = {})
      Refund.all(options.merge(profile_id: id))
    end
  end
end

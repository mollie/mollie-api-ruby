module Mollie
  class Chargeback < Base

    attr_accessor :id,
                  :payment,
                  :amount,
                  :chargeback_datetime,
                  :reversed_datetime


    def reversed?
      !!reversed_datetime
    end

    def reversed_datetime=(reversed_datetime)
      @reversed_datetime = Time.parse(reversed_datetime) rescue nil
    end

    def chargeback_datetime=(chargeback_datetime)
      @chargeback_datetime = Time.parse(chargeback_datetime) rescue nil
    end

    def amount=(amount)
      @amount = BigDecimal.new(amount.to_s) if amount
    end

    def payment=(payment)
      if payment.is_a?(Hash)
        @payment = Payment.new(payment)
      else
        @payment = payment
      end
    end
  end
end

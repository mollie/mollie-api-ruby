module Mollie
  class Invoice < Base
    STATUS_OPEN    = "open"
    STATUS_PAID    = "paid"
    STATUS_OVERDUE = "overdue"

    class Line < Base
      attr_accessor :period, :description, :count, :vat_percentage, :amount

      def amount=(amount)
        @amount = Mollie::Amount.new(amount)
      end
    end

    attr_accessor :id,
                  :reference,
                  :vat_number,
                  :status,
                  :issued_at,
                  :paid_at,
                  :due_at,
                  :net_amount,
                  :vat_amount,
                  :gross_amount,
                  :lines,
                  :_links

    alias_method :links, :_links

    def open?
      status == STATUS_OPEN
    end

    def paid?
      status == STATUS_PAID
    end

    def overdue?
      status == STATUS_OVERDUE
    end

    def net_amount=(net_amount)
      @net_amount = Mollie::Amount.new(net_amount)
    end

    def vat_amount=(vat_amount)
      @vat_amount = Mollie::Amount.new(vat_amount)
    end

    def gross_amount=(gross_amount)
      @gross_amount = Mollie::Amount.new(gross_amount)
    end

    def issued_at=(issued_at)
      @issued_at = Time.parse(issued_at) rescue nil
    end

    def due_at=(due_at)
      @due_at = Time.parse(due_at) rescue nil
    end

    def lines=(lines)
      @lines = lines.map { |line| Line.new(line) }
    end

    def pdf
      links && links['pdf']['href']
    end
  end
end

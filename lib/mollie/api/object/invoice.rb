module Mollie
  module API
    module Object
      class Invoice < Base
        STATUS_OPEN    = "open"
        STATUS_PAID    = "paid"
        STATUS_OVERDUE = "overdue"

        class Amount < Base
          attr_accessor :net, :vat, :gross

          def net=(net)
            @net = BigDecimal.new(net.to_s)
          end

          def vat=(vat)
            @vat = BigDecimal.new(vat.to_s, 2)
          end

          def gross=(gross)
            @gross = BigDecimal.new(gross.to_s)
          end
        end

        class Line < Base
          attr_accessor :period, :description, :count, :vat_percentage, :amount

          def amount=(amount)
            @amount = BigDecimal.new(amount.to_s)
          end
        end

        attr_accessor :resource, :id, :reference, :vat_number, :status,
                      :issue_date, :due_date, :amount, :lines, :links

        def open?
          status == STATUS_OPEN
        end

        def paid?
          status == STATUS_PAID
        end

        def overdue?
          status == STATUS_OVERDUE
        end

        def amount=(amount)
          @amount = Amount.new(amount)
        end

        def issue_date=(issue_date)
          @issue_date = Time.parse(issue_date) rescue nil
        end

        def due_date=(due_date)
          @due_date = Time.parse(due_date) rescue nil
        end

        def lines=(lines)
          @lines = lines.map { |line| Line.new(line) }
        end

        def pdf
          links && links['pdf']
        end
      end
    end
  end
end

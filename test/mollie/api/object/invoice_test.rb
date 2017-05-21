require 'helper'

module Mollie
  module API
    module Object
      class InvoiceTest < Test::Unit::TestCase
        def test_setting_attributes
          attributes = {
              resource:   "invoice",
              id:         "inv_xBEbP9rvAq",
              reference:  "2016.10000",
              vat_number: "NL001234567B01",
              status:     "open",
              issue_date: "2016-08-31",
              due_date:   "2016-09-14",
              amount:     {
                  net:   "45.00",
                  vat:   "9.45",
                  gross: "54.45"
              },
              lines:      [{
                               period:         "2016-09",
                               description:    "iDEAL transactiekosten",
                               count:          100,
                               vat_percentage: 21,
                               amount:         "45.00"
                           }],
              links:      {
                  'pdf' => "https://www.mollie.com/beheer/facturen/2016.10000/52981a39788e5e0acaf71bbf570e941f/"
              }
          }

          invoice = Invoice.new(attributes)

          assert_equal "invoice", invoice.resource
          assert_equal "inv_xBEbP9rvAq", invoice.id
          assert_equal "2016.10000", invoice.reference
          assert_equal "NL001234567B01", invoice.vat_number
          assert_equal "open", invoice.status
          assert_equal Time.parse("2016-08-31"), invoice.issue_date
          assert_equal Time.parse("2016-09-14"), invoice.due_date
          assert_equal 45.0, invoice.amount.net
          assert_equal BigDecimal.new(9.45, 3), invoice.amount.vat
          assert_equal 54.45, invoice.amount.gross

          line = invoice.lines.first
          assert_equal "2016-09", line.period
          assert_equal "iDEAL transactiekosten", line.description
          assert_equal 100, line.count
          assert_equal 21, line.vat_percentage
          assert_equal 45.0, line.amount


          assert_equal "https://www.mollie.com/beheer/facturen/2016.10000/52981a39788e5e0acaf71bbf570e941f/", invoice.pdf
        end
      end
    end
  end
end

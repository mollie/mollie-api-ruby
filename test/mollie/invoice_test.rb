require 'helper'

module Mollie
  class InvoiceTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:         "inv_xBEbP9rvAq",
        reference:  "2016.10000",
        vat_number: "NL001234567B01",
        status:     "open",
        issued_at:  "2016-08-31",
        due_at:     "2016-09-14",
        net_amount: {
          value:    "45.00",
          currency: "EUR"
        },
        vat_amount: {
          value:    "9.45",
          currency: "EUR"
        },
        gross_amount: {
          value:    "54.45",
          currency: "EUR"
        },
        lines: [
          {
            period: "2016-09",
            description: "iDEAL transactiekosten",
            count: 100,
            vat_percentage: 21,
            amount: {
              value:    "45.00",
              currency: "EUR"
            }
          }
        ],
        _links: {
          "pdf" => {
            "href" => "https://www.mollie.com/beheer/facturen/2016.10000/52981a39788e5e0acaf71bbf570e941f/",
            "type" => "application/pdf"
          }
        }
      }

      invoice = Invoice.new(attributes)

      assert_equal "inv_xBEbP9rvAq", invoice.id
      assert_equal "2016.10000", invoice.reference
      assert_equal "NL001234567B01", invoice.vat_number
      assert_equal "open", invoice.status
      assert_equal Time.parse("2016-08-31"), invoice.issued_at
      assert_equal Time.parse("2016-09-14"), invoice.due_at
      assert_equal 45.0, invoice.net_amount.value
      assert_equal 'EUR', invoice.net_amount.currency
      assert_equal BigDecimal.new(9.45, 3), invoice.vat_amount.value
      assert_equal 'EUR', invoice.vat_amount.currency
      assert_equal 54.45, invoice.gross_amount.value
      assert_equal 'EUR', invoice.gross_amount.currency

      line = invoice.lines.first
      assert_equal "2016-09", line.period
      assert_equal "iDEAL transactiekosten", line.description
      assert_equal 100, line.count
      assert_equal 21, line.vat_percentage
      assert_equal 45.0, line.amount.value
      assert_equal 'EUR', line.amount.currency

      assert_equal "https://www.mollie.com/beheer/facturen/2016.10000/52981a39788e5e0acaf71bbf570e941f/", invoice.pdf
    end
  end
end

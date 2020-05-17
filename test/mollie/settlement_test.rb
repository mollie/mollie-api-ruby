require 'helper'

module Mollie
  class SettlementTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:         'stl_jDk30akdN',
        reference:  '1234567.1511.03',
        settled_at: '2015-11-06T06:00:02.0Z',
        amount:     { 'value' => 39.75, 'currency' => 'EUR' },
        periods:    {
          '2015' => {
            '11' => {
              revenue: [
                {
                  description: 'iDEAL',
                  method:      'ideal',
                  count:       6,
                  amount_net: {
                    value:    '86.1000',
                    currency: 'EUR'
                  },
                  amount_vat: nil,
                  amount_gross: {
                    value:    '86.1000',
                    currency: 'EUR'
                  }
                },
                {
                  description: 'Refunds iDEAL',
                  method:      'refund',
                  count:       2,
                  amount_net: {
                    value:    '-43.2000',
                    currency: 'EUR'
                  },
                  amount_vat: nil,
                  amount_gross: {
                    value:    '43.2000',
                    currency: 'EUR'
                  }
                }
              ],
              costs: [
                {
                  description: 'iDEAL',
                  method:      'ideal',
                  count:       6,
                  rate: {
                    fixed: {
                      value:    '0.3500',
                      currency: 'EUR'
                    },
                    percentage: nil
                  },
                  amount_net: {
                    value:    '2.1000',
                    currency: 'EUR'
                  },
                  amount_vat: {
                    value:    '0.4410',
                    currency: 'EUR'
                  },
                  amount_gross: {
                    value:    '2.5410',
                    currency: 'EUR'
                  }
                },
                {
                  description: 'Refunds iDEAL',
                  method:      'refund',
                  count:       2,
                  rate:        {
                    fixed: {
                      value:    '0.3500',
                      currency: 'EUR'
                    },
                    percentage: nil
                  },
                  amount_net: {
                    value:    '0.5000',
                    currency: 'EUR'
                  },
                  amount_vat: {
                    value:    '0.1050',
                    currency: 'EUR'
                  },
                  amount_gross: {
                    value:    '0.6050',
                    currency: 'EUR'
                  }
                }
              ],
              invoice_id: 'inv_FrvewDA3Pr'
            }
          }
        },
        _links: {
          'payments' => {
            'href' => 'https://api.mollie.com/v2/settlements/stl_jDk30akdN/payments',
            'type' => 'application/hal+json'
          },
          'refunds' => {
            'href' => 'https://api.mollie.com/v2/settlements/stl_jDk30akdN/refunds',
            'type' => 'application/hal+json'
          },
          'chargebacks' => {
            'href' => 'https://api.mollie.com/v2/settlements/stl_jDk30akdN/chargebacks',
            'type' => 'application/hal+json'
          }
        }
      }

      settlement = Settlement.new(attributes)

      assert_equal 'stl_jDk30akdN', settlement.id
      assert_equal '1234567.1511.03', settlement.reference
      assert_equal Time.parse('2015-11-06T06:00:02.0Z'), settlement.settled_at
      assert_equal 39.75, settlement.amount.value
      assert_equal 'EUR', settlement.amount.currency

      assert_equal 'iDEAL', settlement.periods[:'2015'][:'11'].revenue[0].description
      assert_equal 'ideal', settlement.periods[:'2015'][:'11'].revenue[0][:method]
      assert_equal 6, settlement.periods[:'2015'][:'11'].revenue[0].count
      assert_equal '86.1000', settlement.periods[:'2015'][:'11'].revenue[0].amount_net.value
      assert_equal nil, settlement.periods[:'2015'][:'11'].revenue[0].amount_vat
      assert_equal '86.1000', settlement.periods[:'2015'][:'11'].revenue[0].amount_gross.value

      assert_equal 'Refunds iDEAL', settlement.periods[:'2015'][:'11'].revenue[1].description
      assert_equal 'refund', settlement.periods[:'2015'][:'11'].revenue[1][:method]
      assert_equal 2, settlement.periods[:'2015'][:'11'].revenue[1].count
      assert_equal '-43.2000', settlement.periods[:'2015'][:'11'].revenue[1].amount_net.value
      assert_equal nil, settlement.periods[:'2015'][:'11'].revenue[1].amount_vat
      assert_equal '43.2000', settlement.periods[:'2015'][:'11'].revenue[1].amount_gross.value

      assert_equal 'iDEAL', settlement.periods[:'2015'][:'11'].costs[0].description
      assert_equal 'ideal', settlement.periods[:'2015'][:'11'].costs[0][:method]
      assert_equal 6, settlement.periods[:'2015'][:'11'].costs[0].count
      assert_equal '0.3500', settlement.periods[:'2015'][:'11'].costs[0].rate.fixed.value
      assert_equal nil, settlement.periods[:'2015'][:'11'].costs[0].rate.percentage
      assert_equal '2.1000', settlement.periods[:'2015'][:'11'].costs[0].amount_net.value
      assert_equal '0.4410', settlement.periods[:'2015'][:'11'].costs[0].amount_vat.value
      assert_equal '2.5410', settlement.periods[:'2015'][:'11'].costs[0].amount_gross.value

      assert_equal 'Refunds iDEAL', settlement.periods[:'2015'][:'11'].costs[1].description
      assert_equal 'refund', settlement.periods[:'2015'][:'11'].costs[1][:method]
      assert_equal 2, settlement.periods[:'2015'][:'11'].costs[1].count
      assert_equal '0.3500', settlement.periods[:'2015'][:'11'].costs[1].rate.fixed.value
      assert_equal nil, settlement.periods[:'2015'][:'11'].costs[1].rate.percentage
      assert_equal '0.5000', settlement.periods[:'2015'][:'11'].costs[1].amount_net.value
      assert_equal '0.1050', settlement.periods[:'2015'][:'11'].costs[1].amount_vat.value
      assert_equal '0.6050', settlement.periods[:'2015'][:'11'].costs[1].amount_gross.value

      assert_equal 'inv_FrvewDA3Pr', settlement.periods[:'2015'][:'11'].invoice_id
    end

    def test_status_open
      assert Settlement.new(status: Settlement::STATUS_OPEN).open?
      assert !Settlement.new(status: 'not-open').open?
    end

    def test_status_pending
      assert Settlement.new(status: Settlement::STATUS_PENDING).pending?
      assert !Settlement.new(status: 'not-pending').pending?
    end

    def test_status_paidout
      assert Settlement.new(status: Settlement::STATUS_PAIDOUT).paidout?
      assert !Settlement.new(status: 'not-paidout').paidout?
    end

    def test_status_failed
      assert Settlement.new(status: Settlement::STATUS_FAILED).failed?
      assert !Settlement.new(status: 'not-failed').failed?
    end

    def test_open_settlement
      stub_request(:get, 'https://api.mollie.com/v2/settlements/open')
        .to_return(status: 200, body: %({"id":"set-id"}), headers: {})

      settlement = Settlement.open

      assert_kind_of Settlement, settlement
      assert_equal 'set-id', settlement.id
    end

    def test_next_settlement
      stub_request(:get, 'https://api.mollie.com/v2/settlements/next')
        .to_return(status: 200, body: %({"id":"set-id"}), headers: {})

      settlement = Settlement.next

      assert_kind_of Settlement, settlement
      assert_equal 'set-id', settlement.id
    end

    def test_list_payments
      stub_request(:get, 'https://api.mollie.com/v2/settlements/stl-id/payments')
        .to_return(status: 200, body: %(
          { "_embedded" : {"payments" : [{ "id": "pay-id", "settlement_id": "stl-id" }]}}
        ), headers: {})

      payments = Settlement.new(id: 'stl-id').payments
      assert_equal Settlement::Payment, payments.klass
      assert_equal 'pay-id', payments.first.id
    end

    def test_list_refunds
      stub_request(:get, 'https://api.mollie.com/v2/settlements/stl-id/refunds')
        .to_return(status: 200, body: %(
          { "_embedded" : {"refunds" : [{ "id": "ref-id", "settlement_id": "stl-id" }]}}
        ), headers: {})

      refunds = Settlement.new(id: 'stl-id').refunds
      assert_equal Settlement::Refund, refunds.klass
      assert_equal 'ref-id', refunds.first.id
    end

    def test_list_chargebacks
      stub_request(:get, 'https://api.mollie.com/v2/settlements/stl-id/chargebacks')
        .to_return(status: 200, body: %(
          { "_embedded" : {"chargebacks" : [{ "id": "chb-id", "settlement_id": "stl-id" }]}}
        ), headers: {})

      chargebacks = Settlement.new(id: 'stl-id').chargebacks
      assert_equal Settlement::Chargeback, chargebacks.klass
      assert_equal 'chb-id', chargebacks.first.id
    end

    def test_list_captures
      stub_request(:get, 'https://api.mollie.com/v2/settlements/stl-id/captures')
        .to_return(status: 200, body: %(
          { "_embedded" : {"captures" : [{ "id": "cpt-id", "settlement_id": "stl-id" }]}}
        ), headers: {})

      captures = Settlement.new(id: 'stl-id').captures
      assert_equal Settlement::Capture, captures.klass
      assert_equal 'cpt-id', captures.first.id
    end

    def test_get_invoice
      stub_request(:get, 'https://api.mollie.com/v2/settlements/stl_jDk30akdN')
        .to_return(
          status: 200,
          body: %(
            {
              "resource": "settlement",
              "id": "stl_jDk30akdN",
              "invoice_id": "inv_FrvewDA3Pr"
            }
          )
        )

      stub_request(:get, 'https://api.mollie.com/v2/invoices/inv_FrvewDA3Pr')
        .to_return(status: 200, body: %(
          {
            "resource": "invoice",
            "id": "inv_FrvewDA3Pr"
          }
        ))

      settlement = Settlement.get('stl_jDk30akdN')
      assert_equal 'inv_FrvewDA3Pr', settlement.invoice.id
    end

    def test_nil_invoice
      settlement = Settlement.new(id: 'stl_jDk30akdN')
      assert_nil settlement.invoice
    end
  end
end

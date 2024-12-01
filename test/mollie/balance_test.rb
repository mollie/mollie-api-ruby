require "helper"

module Mollie
  class BalanceTest < Test::Unit::TestCase
    GET_BALANCE = read_fixture('balances/get.json')
    GET_BALANCE_REPORT = read_fixture('balances/report.json')
    LIST_BALANCES = read_fixture('balances/list.json')
    LIST_BALANCE_TRANSACTIONS = read_fixture('balances/list_transactions.json')

    def test_setting_attributes
      attributes = {
        id: "bal_gVMhHKqSSRYJyPsuoPNFH",
        mode: "live",
        currency: "EUR",
        description: "Primary balance",
        available_amount: { "value" => "0.00", "currency" => "EUR" },
        pending_amount: { "value" => "0.00", "currency" => "EUR" },
        transfer_frequency: "twice-a-month",
        transfer_threshold: { "value" => "5.00", "currency" => "EUR" },
        transfer_reference: "Mollie settlement",
        transfer_destination: {
          type: "bank-account",
          beneficiary_name: "John Doe",
          bank_account: "NL55INGB0000000000"
        },
        status: "active",
        created_at:  "2018-03-20T09:13:37+00:00",
      }

      balance = Mollie::Balance.new(attributes)

      assert_equal "bal_gVMhHKqSSRYJyPsuoPNFH", balance.id
      assert_equal "live", balance.mode
      assert_equal "EUR", balance.currency
      assert_equal "Primary balance", balance.description
      assert_equal BigDecimal("0.00"), balance.available_amount.value
      assert_equal "EUR", balance.available_amount.currency
      assert_equal BigDecimal("0.00"), balance.pending_amount.value
      assert_equal "EUR", balance.pending_amount.currency
      assert_equal "twice-a-month", balance.transfer_frequency
      assert_equal BigDecimal("5.00"), balance.transfer_threshold.value
      assert_equal "EUR", balance.transfer_threshold.currency
      assert_equal "Mollie settlement", balance.transfer_reference
      assert_equal "bank-account", balance.transfer_destination.type
      assert_equal "John Doe", balance.transfer_destination.beneficiary_name
      assert_equal "NL55INGB0000000000", balance.transfer_destination.bank_account
      assert_equal "active", balance.status
      assert_equal Time.parse('2018-03-20T09:13:37+00:00'), balance.created_at
    end

    def test_get_balance
      stub_request(:get, "https://api.mollie.com/v2/balances/bal_gVMhHKqSSRYJyPsuoPNFH")
        .to_return(status: 200, body: GET_BALANCE, headers: {})

      balance = Balance.get("bal_gVMhHKqSSRYJyPsuoPNFH")
      assert_equal "bal_gVMhHKqSSRYJyPsuoPNFH", balance.id
    end

    def test_list_balances
      stub_request(:get, 'https://api.mollie.com/v2/balances')
        .to_return(status: 200, body: LIST_BALANCES, headers: {})

      balances = Balance.all
      assert_equal 3, balances.size
      assert_equal 'bal_one', balances[0].id
      assert_equal 'bal_two', balances[1].id
      assert_equal 'bal_three', balances[2].id
    end

    def test_primary
      stub_request(:get, "https://api.mollie.com/v2/balances/primary")
        .to_return(status: 200, body: GET_BALANCE, headers: {})

      balance = Balance.primary
      assert_equal "bal_gVMhHKqSSRYJyPsuoPNFH", balance.id
    end

    def test_report
      stub_request(:get, "https://api.mollie.com/v2/balances/bal_gVMhHKqSSRYJyPsuoPNFH")
        .to_return(status: 200, body: GET_BALANCE, headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/balances/bal_gVMhHKqSSRYJyPsuoPNFH/report')
        .to_return(status: 200, body: GET_BALANCE_REPORT, headers: {})

      report = Balance.get("bal_gVMhHKqSSRYJyPsuoPNFH").report

      assert_equal Date.parse("2024-01-01"), report.from
      assert_equal Date.parse("2024-01-31"), report.until
      assert_equal "transaction-categories", report.grouping
      assert_equal "4.98", report.totals.dig("payments", "pending", "amount", "value")
      assert_equal "-0.36", report.totals.dig("fee_prepayments", "moved_to_available", "amount", "value")
    end

    def test_list_transactions
      stub_request(:get, "https://api.mollie.com/v2/balances/bal_gVMhHKqSSRYJyPsuoPNFH")
        .to_return(status: 200, body: GET_BALANCE, headers: {})

      stub_request(:get, 'https://api.mollie.com/v2/balances/bal_gVMhHKqSSRYJyPsuoPNFH/transactions')
        .to_return(status: 200, body: LIST_BALANCE_TRANSACTIONS, headers: {})

      transactions = Balance.get("bal_gVMhHKqSSRYJyPsuoPNFH").transactions
      assert_equal 2, transactions.size

      assert_equal "baltr_QM24QwzUWR4ev4Xfgyt29A", transactions[0].id
      assert_equal "baltr_WhmDwNYR87FPDbiwBhUXCh", transactions[1].id
    end
  end
end

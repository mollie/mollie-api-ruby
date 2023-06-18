require 'helper'

module Mollie
  class TerminalTest < Test::Unit::TestCase
    GET_TERMINAL = read_fixture('terminals/get.json')
    LIST_TERMINALS = read_fixture('terminals/list.json')

    def test_get_terminal
      stub_request(:get, "https://api.mollie.com/v2/terminals/term_7MgL4wea46qkRcoTZjWEH")
        .to_return(status: 200, body: GET_TERMINAL, headers: {})

      terminal = Terminal.get("term_7MgL4wea46qkRcoTZjWEH")

      assert_equal "term_7MgL4wea46qkRcoTZjWEH", terminal.id
      assert_equal "pfl_QkEhN94Ba", terminal.profile_id
      assert_equal "active", terminal.status
      assert_equal "PAX", terminal.brand
      assert_equal "A920", terminal.model
      assert_equal "1234567890", terminal.serial_number
      assert_equal "EUR", terminal.currency
      assert_equal "Terminal #12345", terminal.description
      assert_equal Time.parse("2022-02-12T11:58:35.0Z"), terminal.created_at
      assert_equal Time.parse("2022-11-15T13:32:11+00:00"), terminal.updated_at
      assert_equal Time.parse("2022-02-12T12:13:35.0Z"), terminal.deactivated_at
    end

    def test_status_pending
      assert Terminal.new(status: Terminal::STATUS_PENDING).pending?
      assert !Terminal.new(status: "not-pending").pending?
    end

    def test_status_active
      assert Terminal.new(status: Terminal::STATUS_ACTIVE).active?
      assert !Terminal.new(status: "not-active").active?
    end

    def test_status_inactive
      assert Terminal.new(status: Terminal::STATUS_INACTIVE).inactive?
      assert !Terminal.new(status: "not-inactive").inactive?
    end

    def test_list_terminals
      stub_request(:get, "https://api.mollie.com/v2/terminals")
        .to_return(status: 200, body: LIST_TERMINALS, headers: {})

      terminals = Terminal.all

      assert_equal 3, terminals.size
      assert_equal "terminal_one", terminals[0].id
      assert_equal "terminal_two", terminals[1].id
      assert_equal "terminal_three", terminals[2].id
    end
  end
end

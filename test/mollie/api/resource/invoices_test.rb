require 'helper'

module Mollie
  module API
    module Resource
      class InvoicesTest < Test::Unit::TestCase
        def test_resource_object
          assert_equal Object::Invoice, Invoices.new(nil).resource_object
        end
      end
    end
  end
end

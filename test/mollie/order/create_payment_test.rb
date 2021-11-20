require 'helper'

module Mollie
  class Order
    class PaymentTest < Test::Unit::TestCase
      CREATE_PAYMENT = read_fixture("orders/create_payment.json")

      def test_create_payment
        stub_request(:post, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa/payments")
          .to_return(status: 201, body: CREATE_PAYMENT, headers: {})

        payment = Order::Payment.create(order_id: "ord_kEn1PlbGa")

        assert_kind_of Order::Payment, payment
        assert_equal "tr_ncaPcAhuUV", payment.id
        assert_equal "ord_kEn1PlbGa", payment.order_id
      end
    end
  end
end

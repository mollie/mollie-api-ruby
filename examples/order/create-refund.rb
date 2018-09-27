# Refund all order lines
order  = Mollie::Order.get('ord_kEn1PlbGa')
refund = order.refund!

# Refund a specific order line
order  = Mollie::Order.get('ord_kEn1PlbGa')
refund = order.refund!(
  lines: [
    {
      id: 'odl_dgtxyl',
      quantity: 1
    }
  ],
  description: "Required quantity not in stock, refunding one photo book."
)

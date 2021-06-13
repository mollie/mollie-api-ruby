orderline_id = "odl_dgtxyl"

order = Mollie::Order::Line.update(
  orderline_id,
  order_id: "ord_kEn1PlbGa",
  sku: "new-sku-12345678"
)

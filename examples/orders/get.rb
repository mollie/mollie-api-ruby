order = Mollie::Order.get("ord_kEn1PlbGa")

# Embed related resources
order = Mollie::Order.get("ord_kEn1PlbGa", embed: "payments,refunds,shipments")

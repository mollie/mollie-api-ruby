order = Mollie::Order.get('ord_kEn1PlbGa')
order.lines[0].cancel

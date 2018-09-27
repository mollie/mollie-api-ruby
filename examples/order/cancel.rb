Mollie::Order.cancel('ord_kEn1PlbGa')

# Cancel an order instance
order = Mollie::Order.get('ord_kEn1PlbGa')
order.cancel

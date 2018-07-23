methods = Mollie::Method.all

# Filter by amount and currency
methods = Mollie::Method.all(amount: { value: '100.00', currency: 'EUR' })

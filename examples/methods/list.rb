methods = Mollie::Method.all

# Filter by amount and currency
methods = Mollie::Method.all(amount: { value: '100.00', currency: 'EUR' })

# Retrieve all payment methods that Mollie offers and can be activated by
# the Organization.
methods = Mollie::Method.all_available

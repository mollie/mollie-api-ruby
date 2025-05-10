# Retrieve all enabled payment methods
methods = Mollie::Method.all

# Filter by amount and currency
methods = Mollie::Method.all(amount: { value: '100.00', currency: 'EUR' })

# Retrieve all payment methods that Mollie offers and can be activated by the Organization
methods = Mollie::Method.all_available

# Include issuer details such as which iDEAL or gift card issuers are available
methods = Mollie::Method.all_available(include: "issuers")

# Include pricing for each payment method
methods = Mollie::Method.all_available(include: "pricing")

# Include issuer details and pricing
methods = Mollie::Method.all_available(include: "issuers,pricing")

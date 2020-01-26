method = Mollie::Method.get('ideal')

# Include issuers available for the payment method (e.g. for
# iDEAL, KBC/CBC payment button or gift cards).
method = Mollie::Method.get('ideal', include: 'issuers')

# Include pricing for each payment method
method = Mollie::Method.get('ideal', include: 'pricing')

# Include both issuers and pricing
method = Mollie::Method.get('ideal', include: 'issuers,pricing')

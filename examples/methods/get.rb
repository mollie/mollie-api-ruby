method = Mollie::Method.get('ideal')

# Include iDEAL issuers
method = Mollie::Method.get('ideal', include: 'issuers')

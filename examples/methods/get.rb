method = Mollie::Method.get('ideal')

# Include issuer details such as which iDEAL or gift card issuers are available
method = Mollie::Method.get('ideal', include: 'issuers')

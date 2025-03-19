payment = Mollie::Payment.get('tr_7UhSN1zuXS')

# With embedded resources
payment = Mollie::Payment.get('tr_7UhSN1zuXS', embed: 'captures,chargebacks,refunds')

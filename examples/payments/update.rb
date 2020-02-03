payment = Mollie::Payment.update(
  'tr_7UhSN1zuXS',
  description: 'Order #98765',
  metadata: {
    order_id: '98765'
  }
)

refund = Mollie::Payment::Refund.create(
  payment_id:  'tr_7UhSN1zuXS',
  amount:      { value: '5.00', currency: 'EUR' },
  description: 'Did not like it'
)

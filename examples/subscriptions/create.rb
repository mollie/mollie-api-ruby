subscription = Mollie::Customer::Subscription.create(
  customer_id: 'cst_5a2pPrwaWy',
  amount:      { value: '20.00', currency: 'EUR' },
  times:       4,
  interval:    '3 months',
  description: 'Quarterly payment',
  metadata:    { my_field: 'value' },
  webhook_url: 'https://webshop.example.org/payments/webhook/',
)

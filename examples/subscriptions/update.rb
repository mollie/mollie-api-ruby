subscription = Mollie::Customer::Subscription.update(
  'sub_rVKGtNd6s3',
  customer_id: 'cst_5a2pPrwaWy',
  amount: { value: '20.00', currency: 'EUR' }
)

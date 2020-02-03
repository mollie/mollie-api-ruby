# List all subscriptions
subscriptions = Mollie::Subscription.all

# List all subscriptions for a customer
subscriptions = Mollie::Customer::Subscription.all(customer_id: 'cst_5a2pPrwaWy')

subscription = Mollie::Customer::Subscription.create(
  amount:      { value: "20.00", currency: "EUR" },
  times:       4,
  interval:    "3 months",
  description: "Quarterly payment",
  webhook_url: "https://webshop.example.org/payments/webhook/"
)

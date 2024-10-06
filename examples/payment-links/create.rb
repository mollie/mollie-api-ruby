payment_link = Mollie::PaymentLink.create(
  description: "Bicycle tires",
  amount: { currency: "EUR", value: "24.95" }
)


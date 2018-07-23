payment = Mollie::Customer::Payment.create(
  customer_id:  "cst_8wmqcHMN4U",
  amount:       { value: "10.00", currency: "EUR" },
  description:  "First payment",
  redirect_url: "https://webshop.example.org/order/12345/"
)

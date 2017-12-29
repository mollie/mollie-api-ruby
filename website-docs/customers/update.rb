require 'mollie-api-ruby'

begin
  customer = Mollie::Customer.update(
    "cst_8wmqcHMN4U",
    email:   "otherjohn@example.com",
    api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end

<p align="center">
  <img src="https://info.mollie.com/hubfs/github/ruby/logo.png" width="128" height="128"/>
</p>
<h1 align="center">Mollie API client for Ruby</h1>

<img src="https://info.mollie.com/hubfs/github/ruby/editor.png" />

> LOOKING FOR VERSION v2.2.X README? [CLICK HERE](https://github.com/mollie/mollie-api-ruby/tree/2.2.x)

> LOOKING FOR VERSION v3.1.X README? [CLICK HERE](https://github.com/mollie/mollie-api-ruby/tree/3.1.x)

[![Gem Version](https://badge.fury.io/rb/mollie-api-ruby.svg)](https://badge.fury.io/rb/mollie-api-ruby)
[![](https://travis-ci.org/mollie/mollie-api-ruby.png)](https://travis-ci.org/mollie/mollie-api-ruby)

Accepting [iDEAL](https://www.mollie.com/en/payments/ideal), [Bancontact](https://www.mollie.com/en/payments/bancontact), [SOFORT Banking](https://www.mollie.com/en/payments/sofort), [Creditcard](https://www.mollie.com/en/payments/credit-card), [SEPA Bank transfer](https://www.mollie.com/en/payments/bank-transfer), [SEPA Direct debit](https://www.mollie.com/en/payments/direct-debit), [PayPal](https://www.mollie.com/en/payments/paypal), [KBC/CBC Payment Button](https://www.mollie.com/en/payments/kbc-cbc), [Belfius Direct Net](https://www.mollie.com/en/payments/belfius), [paysafecard](https://www.mollie.com/en/payments/paysafecard), [ING Home’Pay](https://www.mollie.com/en/payments/ing-homepay), [Gift cards](https://www.mollie.com/en/payments/gift-cards), [EPS](https://www.mollie.com/en/payments/eps) and [Giropay](https://www.mollie.com/en/payments/giropay) online payments without fixed monthly costs or any punishing registration procedures. Just use the Mollie API to receive payments directly on your website or easily refund transactions to your customers.

## Requirements
To use the Mollie API client, the following things are required:

+ Get yourself a free [Mollie account](https://www.mollie.com/dashboard/signup). No sign up costs.
+ Create a new [Website profile](https://www.mollie.com/dashboard/settings/profiles) to generate API keys (live and test mode) and setup your webhook.
+ Now you're ready to use the Mollie API client in test mode.
+ In order to accept payments in live mode, payment methods must be activated in your account. Follow [a few of steps](https://www.mollie.nl/beheer/diensten), and let us handle the rest.

## Installation

By far the easiest way to install the Mollie API client is to install it with [gem](http://rubygems.org/).

```
# Gemfile
gem 'mollie-api-ruby'

$ gem install mollie-api-ruby
```

You may also git checkout or [download all the files](https://github.com/mollie/mollie-api-ruby/archive/master.zip), and include the Mollie API client manually.

## How to receive payments

To successfully receive a payment, these steps should be implemented:

1. Use the Mollie API client to create a payment with the requested amount, description and optionally, a payment method. It is important to specify a unique redirect URL where the customer is supposed to return to after the payment is completed.

2. Immediately after the payment is completed, our platform will send an asynchronous request to the configured webhook to allow the payment details to be retrieved, so you know when exactly to start processing the customer's order.

3. The customer returns, and should be satisfied to see that the order was paid and is now being processed.

## Getting started

Require the Mollie API Client. *Not required when used with a Gemfile*

```ruby
require 'mollie-api-ruby'
```

Create an initializer and add the following line:

```ruby
Mollie::Client.configure do |config|
  config.api_key = '<your-api-key>'
end
```

You can also include the API Key in each request you make, for instance if you are using the Connect API:

```ruby
Mollie::Payment.get('pay-id', api_key: '<your-api-key>')
```

If you need to do multiple calls with the same API Key, use the following helper:

```ruby
Mollie::Client.with_api_key('<your-api-key>') do
  mandates = Mollie::Customer::Mandate.all(customer_id: params[:customer_id])
  if mandates.any?
    payment = Mollie::Payment.create(
      amount:       { value: '10.00', currency: 'EUR' },
      description:  'My first API payment',
      redirect_url: 'https://webshop.example.org/order/12345/',
      webhook_url:  'https://webshop.example.org/mollie-webhook/'
    )
  end
end
```

### Creating a new payment

```ruby
payment = Mollie::Payment.create(
  amount:       { value: '10.00', currency: 'EUR' },
  description:  'My first API payment',
  redirect_url: 'https://webshop.example.org/order/12345/',
  webhook_url:  'https://webshop.example.org/mollie-webhook/'
)
```

**Note**: If you specify an `amount`, you must specify the *correct* number of decimals.
We strongly recommend sending `value `as a string. Note that even though most currencies
use two decimals, some use three or none, like `JPY`. All amounts returned in the v2
API will use this format.

### Retrieving a payment

```ruby
payment = Mollie::Payment.get(payment.id)

if payment.paid?
  puts 'Payment received.'
end
```

### Refunding payments

The API also supports refunding payments. Note that there is no confirmation and that all refunds are immediate and
definitive. Refunds are only supported for [certain payment methods](https://help.mollie.com/hc/en-us/articles/115000014489-How-do-I-refund-a-payment-to-one-of-my-consumers-).

```ruby
payment = Mollie::Payment.get(payment.id)
refund  = payment.refund!(amount: { value: '10.00', currency: 'EUR' })
```

### Pagination

Fetching all objects of a resource can be convenient. At the same time,
returning too many objects at once can be unpractical from a performance
perspective. Doing so might be too much work for the Mollie API to generate, or
for your website to process. The maximum number of objects returned is 250.

For this reason the Mollie API only returns a subset of the requested set of
objects. In other words, the Mollie API chops the result of a certain API method
call into pages you’re able to programmatically scroll through.

```ruby
payments = Mollie::Payment.all
payments.next
payments.previous
```

## Upgrading

* [Migration from v2.2.x](docs/migration_v2_2_x.md)
* [Migration from v3.x](docs/migration_v3_x.md)

## API documentation ##

If you wish to learn more about our API, please visit the [Mollie API Documentation](https://docs.mollie.com).

## Want to help us make our API client even better?

Want to help us make our API client even better? We take [pull requests](https://github.com/mollie/mollie-api-ruby/pulls?utf8=%E2%9C%93&q=is%3Apr), sure. But how would you like to contribute to a technology oriented organization? Mollie is hiring developers and system engineers. [Check out our vacancies](https://jobs.mollie.com/) or [get in touch](mailto:recruitment@mollie.com).

## License
[BSD (Berkeley Software Distribution) License](https://opensource.org/licenses/bsd-license.php). Copyright (c) 2014-2018, Mollie B.V.

## Support
Contact: [www.mollie.com](https://www.mollie.com) — info@mollie.com — +31 20-612 88 55

+ [More information about iDEAL via Mollie](https://www.mollie.com/en/payments/ideal/)
+ [More information about Credit card via Mollie](https://www.mollie.com/en/payments/credit-card/)
+ [More information about Bancontact via Mollie](https://www.mollie.com/en/payments/bancontact/)
+ [More information about SOFORT Banking via Mollie](https://www.mollie.com/en/payments/sofort/)
+ [More information about SEPA Bank transfer via Mollie](https://www.mollie.com/en/payments/bank-transfer/)
+ [More information about SEPA Direct debit via Mollie](https://www.mollie.com/en/payments/direct-debit/)
+ [More information about PayPal via Mollie](https://www.mollie.com/en/payments/paypal/)
+ [More information about KBC/CBC Payment Button via Mollie](https://www.mollie.com/en/payments/kbc-cbc/)
+ [More information about Belfius Direct Net via Mollie](https://www.mollie.com/en/payments/belfius)
+ [More information about paysafecard via Mollie](https://www.mollie.com/en/payments/paysafecard/)
+ [More information about ING Home’Pay via Mollie](https://www.mollie.com/en/payments/ing-homepay/)
+ [More information about Gift cards via Mollie](https://www.mollie.com/en/payments/gift-cards)
+ [More information about EPS via Mollie](https://www.mollie.com/en/payments/eps)
+ [More information about Giropay via Mollie](https://www.mollie.com/en/payments/giropay)

![Mollie](http://www.mollie.nl/files/Mollie-Logo-Style-Small.png)

# Mollie API client for Ruby #

[![Gem Version](https://badge.fury.io/rb/mollie-api-ruby.svg)](https://badge.fury.io/rb/mollie-api-ruby)
[![](https://travis-ci.org/mollie/mollie-api-ruby.png)](https://travis-ci.org/mollie/mollie-api-ruby)

Accepting [iDEAL](https://www.mollie.com/ideal/), [Bancontact/Mister Cash](https://www.mollie.com/mistercash/), [SOFORT Banking](https://www.mollie.com/sofort/), [Creditcard](https://www.mollie.com/creditcard/), [SEPA Bank transfer](https://www.mollie.com/overboeking/), [SEPA Direct debit](https://www.mollie.com/directdebit/), [Bitcoin](https://www.mollie.com/bitcoin/), [PayPal](https://www.mollie.com/paypal/), [KBC/CBC Payment Button](https://www.mollie.com/kbccbc/), [Belfius Direct Net](https://www.mollie.com/belfiusdirectnet/) and [paysafecard](https://www.mollie.com/paysafecard/) online payments without fixed monthly costs or any punishing registration procedures. Just use the Mollie API to receive payments directly on your website or easily refund transactions to your customers.

## Requirements ##
To use the Mollie API client, the following things are required:

+ Get yourself a free [Mollie account](https://www.mollie.nl/aanmelden). No sign up costs.
+ Create a new [Website profile](https://www.mollie.nl/beheer/account/profielen/) to generate API keys (live and test mode) and setup your webhook.
+ Now you're ready to use the Mollie API client in test mode.
+ In order to accept payments in live mode, payment methods must be activated in your account. Follow [a few of steps](https://www.mollie.nl/beheer/diensten), and let us handle the rest.

## Installation ##

By far the easiest way to install the Mollie API client is to install it with [gem](http://rubygems.org/).

```
$ gem install mollie-api-ruby
```

You may also git checkout or [download all the files](https://github.com/mollie/mollie-api-ruby/archive/master.zip), and include the Mollie API client manually.

## How to receive payments ##

To successfully receive a payment, these steps should be implemented:

1. Use the Mollie API client to create a payment with the requested amount, description and optionally, a payment method. It is important to specify a unique redirect URL where the customer is supposed to return to after the payment is completed.

2. Immediately after the payment is completed, our platform will send an asynchronous request to the configured webhook to allow the payment details to be retrieved, so you know when exactly to start processing the customer's order.

3. The customer returns, and should be satisfied to see that the order was paid and is now being processed.

## Getting started ##

Requiring the Mollie API Client.

```ruby
require 'mollie/api/client'
```

Initializing the Mollie API client, and setting your API key.

```ruby
mollie = Mollie::API::Client.new('test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM')
```

Creating a new payment.

```ruby
payment = mollie.payments.create(
  amount: 10.00,
  description: 'My first API payment',
  redirect_url: 'https://webshop.example.org/order/12345/'
)
```

Retrieving a payment.

```ruby
payment = mollie.payments.get(payment.id)

if payment.paid?
  puts 'Payment received.'
end
```

### Refunding payments ###

The API also supports refunding payments. Note that there is no confirmation and that all refunds are immediate and
definitive. Refunds are only supported for iDEAL, credit card and Bank Transfer payments. Other types of payments cannot
be refunded through our API at the moment.

```ruby
payment = mollie.payments.get(payment.id)
refund  = mollie.payments_refunds.with(payment).create
```

## Examples ##

The examples require [Sinatra](http://rubygems.org/gems/sinatra) so you will need to install that gem first. Afterwards simply run:

```
$ cd mollie-api-ruby
$ ruby examples/app.rb
```

## API documentation ##
If you wish to learn more about our API, please visit the [Mollie Developer Portal](https://www.mollie.com/developer/). API Documentation is available in both Dutch and English.

## License ##
[BSD (Berkeley Software Distribution) License](http://www.opensource.org/licenses/bsd-license.php).
Copyright (c) 2014-2015, Mollie B.V.

## Support ##
Contact: [www.mollie.com](https://www.mollie.com) — info@mollie.com — +31 20-612 88 55

+ [More information about iDEAL via Mollie](https://www.mollie.com/ideal/)
+ [More information about credit card via Mollie](https://www.mollie.com/creditcard/)
+ [More information about Bancontact/Mister Cash via Mollie](https://www.mollie.com/mistercash/)
+ [More information about SOFORT Banking via Mollie](https://www.mollie.com/sofort/)
+ [More information about SEPA Bank transfer via Mollie](https://www.mollie.com/banktransfer/)
+ [More information about SEPA Direct debit via Mollie](https://www.mollie.com/directdebit/)
+ [More information about Bitcoin via Mollie](https://www.mollie.com/bitcoin/)
+ [More information about PayPal via Mollie](https://www.mollie.com/paypal/)
+ [More information about KBC/CBC Payment Button via Mollie](https://www.mollie.com/kbccbc/)
+ [More information about Belfius Direct Net via Mollie](https://www.mollie.com/belfiusdirectnet/)
+ [More information about paysafecard via Mollie](https://www.mollie.com/paysafecard/)

![Powered By Mollie](https://www.mollie.com/images/badge-betaling-medium.png)

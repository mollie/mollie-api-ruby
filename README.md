![Mollie](https://www.mollie.nl/files/Mollie-Logo-Style-Small.png)

# LOOKING FOR VERSION v2.2.X README [CLICK HERE](https://github.com/mollie/mollie-api-ruby/tree/2.2.x) #

# Mollie API client for Ruby #

[![Gem Version](https://badge.fury.io/rb/mollie-api-ruby.svg)](https://badge.fury.io/rb/mollie-api-ruby)
[![](https://travis-ci.org/mollie/mollie-api-ruby.png)](https://travis-ci.org/mollie/mollie-api-ruby)

Accepting [iDEAL](https://www.mollie.com/ideal/), [Bancontact/Mister Cash](https://www.mollie.com/mistercash/), [SOFORT Banking](https://www.mollie.com/sofort/), [Creditcard](https://www.mollie.com/creditcard/), [SEPA Bank transfer](https://www.mollie.com/overboeking/), [SEPA Direct debit](https://www.mollie.com/directdebit/), [Bitcoin](https://www.mollie.com/bitcoin/), [PayPal](https://www.mollie.com/paypal/), [KBC/CBC Payment Button](https://www.mollie.com/kbccbc/), [Belfius Direct Net](https://www.mollie.com/belfiusdirectnet/), [paysafecard](https://www.mollie.com/paysafecard/) and [ING Home’Pay](https://www.mollie.com/ing-homepay/) online payments without fixed monthly costs or any punishing registration procedures. Just use the Mollie API to receive payments directly on your website or easily refund transactions to your customers.

## Requirements ##
To use the Mollie API client, the following things are required:

+ Get yourself a free [Mollie account](https://www.mollie.nl/aanmelden). No sign up costs.
+ Create a new [Website profile](https://www.mollie.nl/beheer/account/profielen/) to generate API keys (live and test mode) and setup your webhook.
+ Now you're ready to use the Mollie API client in test mode.
+ In order to accept payments in live mode, payment methods must be activated in your account. Follow [a few of steps](https://www.mollie.nl/beheer/diensten), and let us handle the rest.

## Installation ##

By far the easiest way to install the Mollie API client is to install it with [gem](http://rubygems.org/).

```
# Gemfile
gem 'mollie-api-ruby'

$ gem install mollie-api-ruby
```

You may also git checkout or [download all the files](https://github.com/mollie/mollie-api-ruby/archive/master.zip), and include the Mollie API client manually.

## How to receive payments ##

To successfully receive a payment, these steps should be implemented:

1. Use the Mollie API client to create a payment with the requested amount, description and optionally, a payment method. It is important to specify a unique redirect URL where the customer is supposed to return to after the payment is completed.

2. Immediately after the payment is completed, our platform will send an asynchronous request to the configured webhook to allow the payment details to be retrieved, so you know when exactly to start processing the customer's order.

3. The customer returns, and should be satisfied to see that the order was paid and is now being processed.

## Getting started ##

Requiring the Mollie API Client. *Not required when used with a Gemfile*

```ruby
require 'mollie-api-ruby'
```

Create an initializer and add the following line:

```ruby
Mollie::Client.configure do |config|
  config.api_key = '<your-api-key>'
end
```

You can also include the API Key in each request you make, for instance if you are using the Connect API

```ruby
Mollie::Payment.get("pay-id", api_key: '<your-api-key>')
```

If you need to do multiple calls with the same API Key, use the following helper

```ruby
Mollie::Client.with_api_key('<your-api-key>') do
  mandates = Mollie::Customer::Mandate.all(customer_id: params[:customer_id])
  if mandates.any?
    payment = Mollie::Payment.create(
      amount:       10.00,
      description:  'My first API payment',
      redirect_url: 'https://webshop.example.org/order/12345/',
      webhook_url:  'https://webshop.example.org/mollie-webhook/'
    )
  end
end
```

Creating a new payment.

```ruby
payment = Mollie::Payment.create(
  amount:       10.00,
  description:  'My first API payment',
  redirect_url: 'https://webshop.example.org/order/12345/',
  webhook_url:  'https://webshop.example.org/mollie-webhook/'
)
```

Retrieving a payment.

```ruby
payment = Mollie::Payment.get(payment.id)

if payment.paid?
  puts 'Payment received.'
end
```

### Refunding payments ###

The API also supports refunding payments. Note that there is no confirmation and that all refunds are immediate and
definitive. Refunds are only supported for iDEAL, credit card and Bank Transfer payments. Other types of payments cannot
be refunded through our API at the moment.

```ruby
payment = Mollie::Payment.get(payment.id)
refund  = payment.refunds.create
```

## Examples ##

In order to run the examples first run `bundle install`

```
$ cd mollie-api-ruby
$ bundle install
$ cd examples
$ rackup
```

## API documentation ##
If you wish to learn more about the Ruby API, download the source code and run the Example app as follows:

```
$ git clone git@github.com:mollie/mollie-api-ruby.git
$ cd mollie-api-ruby
$ bundle
$ cd examples
$ API_KEY=test_xxxxxx rackup
```
You can then browse the swagger documentation on [http://localhost:9292](http://localhost:9292)

If you wish to learn more about our API, please visit the [Mollie Developer Portal](https://www.mollie.com/developer/). API Documentation is available in both Dutch and English.

## Migration from v2.2.x ##

The version 2.2.x used a client that contained methods to call API methods on the mollie servers.
The responses were converted in to Mollie objects and attributes could be retrieved.
Version 3.1.x uses a more Resource oriented approach that fits better with the Active Record principle.
Instead of calling the methods on the client, you now use the Resource class or instance to call the API methods.

You can now require the mollie client by using the gem name.
If you are using bundler and Rails you don't even need to require it anymore

```ruby
# require 'mollie/api/client'
require 'mollie-api-ruby'
```

Instead of creating a client with an API key, the client is now stored as a threadsafe singleton object.
Configuration can now be simplified by adding a global configure block in a Rails initializer or a Rack loader file.


```ruby
# mollie = Mollie::API::Client.new('test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM')
 
# config/initializers/mollie.rb or in your app.rb 
Mollie::Client.configure do |config|
  config.api_key = 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM'
end

# You may also pass a specific API key in the params for each request.
payment = Mollie::Payment.get(api_key: 'test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM')

# Or in a Rails around filter
around_action :set_mollie_key

def set_mollie_key
  Mollie::Client.with_api_key('test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM') do
    yield
  end
end
 
```

Change the client calls to Resource calls

```ruby
# mollie = Mollie::API::Client.new('test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM')
# payment = mollie.payments.create(
#  amount:       10.00,
#  description:  'My first API payment',
#  redirect_url: 'https://webshop.example.org/order/12345/',
#  webhook_url:  'https://webshop.example.org/mollie-webhook/'
#)
 
payment = Mollie::Payment.create(
  amount:       10.00,
  description:  'My first API payment',
  redirect_url: 'https://webshop.example.org/order/12345/',
  webhook_url:  'https://webshop.example.org/mollie-webhook/'
) 
```

The resources created are similar to the old resources but have an extra option to retrieve nested resources

```ruby
# payment = mollie.payments.get(payment.id)
# refund  = mollie.payments_refunds.with(payment).create
payment = Mollie::Payment.get("id")
refund = payment.refunds.create 
```

## License ##
[BSD (Berkeley Software Distribution) License](https://opensource.org/licenses/bsd-license.php).
Copyright (c) 2014-2018, Mollie B.V.

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
+ [More information about ING Home’Pay via Mollie](https://www.mollie.com/ing-homepay/)

# Migration from v2.2.x

The version 2.2.x used a client that contained methods to call API methods on the mollie servers.
The responses were converted in to Mollie objects and attributes could be retrieved.
Version 3.1.x uses a more Resource oriented approach that fits better with the Active Record principle.
Instead of calling the methods on the client, you now use the Resource class or instance to call the API methods.

You can now require the mollie client by using the gem name.
If you are using bundler and Rails you don't even need to require it anymore.

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
  amount:       { value: '10.00', currency: 'EUR' },
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
refund = payment.refunds.create({ amount: '10.00', currency: 'EUR' })
```

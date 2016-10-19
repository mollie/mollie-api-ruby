![Mollie](https://www.mollie.com/files/Mollie-Logo-Style-Small.png)

### Changelog

All notable changes to this project will be documented in this file.


#### v1.4.2 - 2016-10-19
  - Added payment method KBC/CBC Payment Button
  - Fixed an issue where the required `mime-types` dependency did not work correctly ([#32](https://github.com/mollie/mollie-api-ruby/pull/32)).
  - Fixed an issue with customer subscriptions ([#35](https://github.com/mollie/mollie-api-ruby/pull/35)).

#### v1.4.1 - 2016-06-20
  - Added `refunded?` method.

#### v1.4.0 - 2016-06-16
  - Added Subscriptions API.

#### v1.3.0 - 2016-04-14
  - Added Mandates API.
  - Added `recurringType` and `mandateId` to Payments API.

#### v1.2.2 - 2016-03-21
  - The members `customers` and `customers_payments` weren't made public within `attr_reader` ([#21](https://github.com/mollie/mollie-api-ruby/pull/21)).
  - Updated the bundled CA's cacert.pem file to date `Jan 20, 2016`.

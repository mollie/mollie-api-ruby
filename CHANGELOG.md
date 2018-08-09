![Mollie](https://www.mollie.com/files/Mollie-Logo-Style-Small.png)

### Changelog

All notable changes to this project will be documented in this file.

#### 4.0 - 2018-07-23

  - Migrated to the v2 API
  - Refer to the [migration guide](/docs/migration_v3_x.md) for a complete list of changes
  - Dropped Ruby 2.0.0 support.

#### 3.1.0 - ....
  - Removed old api

#### 3.0.0 - ....
  - Introduced new api
  - Deprecated old api

#### 2.2.1 - 2017-09-13
  - Added support for gift card method.
  - Added support for `invoice` endpoint.
  - Improved support for `refunds` endpoint.
  - Added and updated examples.

#### 2.2.0 - 2017-04-21
  - Add support for organizations, permissions, profiles, settlement and profiles/apikeys resources ([#54](https://github.com/mollie/mollie-api-ruby/issues/54)).
  - Remove `jruby` from the build.

#### 2.1.0 - 2017-02-06
  - Add pagination support to resources ([#25](https://github.com/mollie/mollie-api-ruby/issues/25)).

#### 2.0.1 - 2016-12-16
  - Update bundled cacert.pem file. Follows Mozilla's recommendations on invalid certificates.

#### 2.0.0 - 2016-11-10
  - Refactor to a more ruby like library.
    - all methods use underscores
    - payloads to call api functions will be camel cased before sending
    - getters and setters are now just attr_accessors and omit get and set

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

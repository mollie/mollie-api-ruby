![Mollie](https://www.mollie.com/files/Mollie-Logo-Style-Small.png)

### Changelog

All notable changes to this project will be documented in this file.

## 4.16.0 - 2025-03-19

  - (9caf303) Support embedded payment captures and chargebacks
  - (ed1916e) Add support for embedded refunds
  - (c322aca) Avoid frozen string literals warnings with Ruby 3.4

## 4.15.0 - 2024-12-01

  - (f659c19) Add Balance API

## 4.14.0 - 2024-11-02

  - (0876f2b) Add Payment Links API
  - (9ab5e1b) Fix dependency warnings (#176)
  - (87a6c9a) Update supported payment methods
  - (afb6251) IMP-610: Use correct authorize URL
  - (002708c) changelog_uri to gemspec

## 4.13.0 - 2024-05-22

  - (09489be) Add HTTP response details to RequestError
  - (fe5d114) Add Terminals API

## 4.12.0 - 2023-01-29

  - (f180b47) Add support for idempotency keys
  - (f0a47d1) Payment: add support for cancel_url
  - (9db60b3) Order: add support for cancel_url
  - (2f88990) Require non-empty ID when fetching a resource

## 4.11.0 - 2022-03-01

  - (1ef339e) Add Partner API

## 4.10.0 - 2021-11-20

:warning: The `Profile#category_code` attribute is deprecated and will be removed in 2022. Please use the `business_category` parameter instead.

  - (f0e695c) Order: add methods to retrieve embedded resources
  - (e16864c) Order: add class to create order payments
  - (5175cd3) Profile: add `business_category` attribute
  - (3d2e370) Payment: add `amount_charged_back` attribute
  - (3d6b403) Fix assignment method for `amount_captured`
  - (37280c3) Migrate from Travis CI to GitHub Actions
  - (33bb6bb) Add example to update orderlines
  - (c70dbf6) fix: orderline update returns incorrect class
  - (ca5935d) Add example to retrieve all available payment methods
  - (457b853) Add "List all payment methods" API
  - (9d8eebc) Method: add status attribute (#147)
  - (506d52e) fix: Include parent resource in pagination calls
  - (7e3b98d) Fix onboarding dashboard URL.

## 4.9.0 - 2020-05-17

  - Settlement: add `captures` helper method.

## 4.8.0 - 2020-05-12

  - Implement API features and changes from the changelog up to and including Friday, April 3rd, 2020.

## 4.7.1 - 2020-02-13

  - Fix `Capture#shipment` API call.

## 4.7.0 - 2020-02-03

  - Implemented various API features from the changelog up to and including Tuesday, September 24th, 2019.

## 4.6.2 - 2019-11-21

  - Added timeouts configuration for Net::HTTP

## 4.6.1 - 2019-11-20

  - Update root certificates

## 4.6.0 - 2019-10-01

  - Add Onboarding APIs (Get onboarding status, Submit onboarding data)

## 4.5.0 - 2019-09-16

  - Add helper method to retrieve payments for subscription.

## 4.4.1 - 2019-08-12

  - Payment: Require customer_id when retrieving a mandate.

## 4.4.0 - 2019-07-11

  - Mandate: add `mode` attribute
  - Organization: add `_links` helper method
  - Organization: add `locale` attribute
  - OrderLine: add `metadata` attribute
  - Method: add `minimumAmount` and `maximumAmount` attributes

### 4.3.1 - 2019-06-08

  - Added the option to pass additional request options when creating a new resource.

#### 4.2 - 2019-05-01

  - Removed the Bitcoin payment method.

#### 4.1 - 2018-10-08

  - Add Capture, Order, and Shipment APIs (#92)

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

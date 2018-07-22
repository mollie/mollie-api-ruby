# Migration from v3.x

Please refer to [Migrating from v1 to v2](https://docs.mollie.com/migrating-v1-to-v2)
for a general overview of the switch to Mollie v2 API.

Code examples can be found in the [/examples](/examples) folder.

## Nested resources

Several helper methods were added to retrieve nested resources. Nested resources
now return a collection or the object itself:

```ruby
payment  = Mollie::Payment.get("tr_7UhSN1zuXS")
refunds  = payment.refunds # => Mollie::List
customer = payment.customer # => Mollie::Customer
```

## Multi-currency

The Ruby client v4 adds support for multi-currency. All amounts are parsed as a
`Mollie::Amount` object.

```ruby
payment = Mollie::Payment.create(
  amount:      { value: '42.10', currency: 'EUR' },
  description: 'My first payment'
)

payment = Mollie::Payment.get("tr_7UhSN1zuXS")
payment.amount # => Mollie::Amount
payment.amount.value # => 42.10 # BigDecimal
payment.amount.currency # => 'EUR'
```

**Note**: If you specify an amount, you must specify the *correct* number of decimals.
We strongly recommend sending value as a string. Note that even though most currencies
use two decimals, some use three or none, like JPY. All amounts returned in the v2
API will use this format.

## Error handling

A `RequestError` is raised for all API error responses. The `RequestError` object
contains the following details:

* `status`: HTTP status code of the response
* `title`: Title of the error
* `detail`: Extra information about the error
* `field`: Field of your request that is likely causing the error. Only available in case of 422 Unprocessable Entity errors.
* `links`: Links to relevant API documentation

# Changes in Mollie API v2

* The identifier for the payment method Bancontact has been renamed from `mistercash` to `bancontact`
* Some resources support embedding of related sub-resources. For instance, when retrieving a payment
any refunds can be embedded by using the `embed: 'refunds'` option. See the
[Get payment documentation](https://docs.mollie.com/reference/v2/payments-api/get-payment) for more information.

## Locale changes

Only full locales with both the language and the country code are supported,
e.g. `nl_NL`. Locales are always returned as full locales.

## Combined date and time fields

Formatting of fields such as `created_at` has been updated to be strictly
compliant to ISO-8601 formatting. Example value: `2018-03-05T12:30:10+00:00`.

## Changes in the Payments API

The following changes have been made in regards to the status of payments:

* The statuses `paidout`, `refunded` and `charged_back` have been removed
* The status `cancelled` has been renamed to `canceled` (US English spelling)
* The individual billing and shipping address parameters that can be used when
creating a credit card or PayPal payment have been replaced by address objects.
Instead of passing `billing_address`, `billing_postal`, `billing_city`, `billing_region`
and/or `billing_country` (or the equivalent fields starting with `shipping`), one
should now pass a `billing_address` (and/or `shipping_address`) object, as follows:

```ruby
{
  amount: { value: '100.00', currency: 'USD' },
  description: 'My first payment',
  billing_address: {
    street_and_number: 'Dorpstraat 1',
    postal_code: '1122 AA',
    city: 'Amsterdam',
    region: 'Noord-Holland',
    country: 'NL'
  }
}
```

The following fields have been changed, renamed or moved:

* `cancelled_datetime` has been renamed to `canceled_at`
* `created_datetime` has been renamed to `created_at`
* `expired_datetime` has been renamed to `expired_at`
* `failed_datetime` has been renamed to `failed_at`
* `paid_datetime` has been renamed to `paid_at`
* `recurring_type` has been renamed to `sequence_type`. This field is now always present. A one-off payment (not the start of a recurring sequence and not a recurring payment) will have the value `oneoff`.
* `failure_reason` has been moved from the Payment resource to the credit card detail object, and no longer available for Bancontact payments.
* `details.bitcoin_amount` is now an amount object in the XBT currency

The following fields have been removed:

* `expiry_period` has been removed from the Payment resource. You can use `expires_at` which contains the same information.
* `issuer` has been removed from the Payment resource. You can however, still pass it to the Create payment API.
* `details.bitcoin_rate` has been removed from the Bitcoin detail object
* `details.card_country` has been removed from the credit card detail object
* The option to include the settlement using the `include` query string parameter has been removed

These new fields have been added:

* `settlement_amount` has been added to the responses of the Payments API, the Refunds API and the Chargebacks API. This optional field will contain the amount that will be settled to your account, converted to the currency your account is settled in. It follows the same syntax as the `amount` property.
  * Note that for refunds and chargebacks, the `value` key of `settlement_amount` will be negative.
  * Any amounts not settled by Mollie will not be reflected in this amount, e.g. PayPal or gift cards.
* `links['status']` has been added to the responses for `banktransfer` payments. Your customer can check the status of their transfer at this URL.
* `links['pay_online']` has been added to the responses for `banktransfer` payments. At this URL your customer can finish the payment using an alternative payment method also activated on your website profile.

## Changes in the Refunds API

The following fields have been changed, renamed or moved:

* `amount` is now mandatory when creating a refund. You must specify both `amount.currency` and `amount.value`.
* The `amount` field is now of the `amount` type and contains a `value` and a `currency`
* `payment`, which contained the payment resource related to the refund, is no longer returned. Instead, the payment ID
is returned by default, in the `payment_id` field. The payment resource can still easily be accessed using the `payment`
helper method.

These new fields have been added:

* `settlement_amount` has been added. See the explanation of the [settlementAmount](https://docs.mollie.com/migrating-v1-to-v2#settlementamount) for the Payments API.

## Changes in the Chargebacks API

The following fields have been changed, renamed or moved:

* The `amount` field is now of the `amount` type and contains a `value` and a `currency`
* `chargeback_datetime` has been renamed to `created_at`
* `reversed_datetime` has been renamed to `reversed_at`. This field is now only returned if the chargeback is reversed.
* `payment`, which contained the payment ID related to the chargeback, has been renamed to `payment_id`. The payment resource can easily be accessed using the `payment` helper method.
* Pagination has been removed, so all fields related to pagination are not available anymore. The list method will now return all chargebacks.

These new fields have been added:

* `settlement_amount` has been added. See the explanation of the [settlementAmount](https://docs.mollie.com/migrating-v1-to-v2#settlementamount) for the Payments API.

## Changes in the Methods API

The following fields have been changed, renamed or moved:

* `amount` including `minimum` and `maximum` have been removed
* Pagination has been removed, so all fields related to pagination are not available anymore. The list method will now return all payment methods.

The following parameters have been changed or added:

* The parameter `recurring_type` has been renamed to `sequence_type`. Possible values are `oneoff`, `first` or `recurring`.
* The parameter `amount` has been added. This should be an object containing `value` and `currency`. Only payment methods that
support the amount/currency will be returned.

## Changes in the Issuers API

The issuers API has been removed. Instead, you can get the issuers via the Get Method API using the `issuers` include.

## Changes in the Customers API

The following fields have been changed, renamed or moved:

* `created_datetime` has been renamed to `created_at`
* `recently_used_methods` has been removed

## Changes in the Subscriptions API

The following changes have been made in regards to the status of subscriptions:

* Subscriptions that are canceled can be retrieved from the API
* The `canceled` status is changed from British English to American English

The following fields have been changed, renamed or moved:

* `created_datetime` has been renamed to `created_at`
* `cancelled_datetime` has been renamed to `canceled_at`, and is now only returned when the subscription is canceled

## Changes in the Profiles API

The following fields have been changed, renamed or removed:

* `created_datetime` has been renamed to `created_at`
* `updated_datetime` has been removed
* `phone` is now formatted in E.164 formatting
* The API keys subresource has been removed

## Changes in the Settlements API

The following fields have been changed, renamed or moved:

* `created_datetime` has been renamed to `created_at`
* `settled_datetime` has been renamed to `settled_at`
* The fields `payment_ids`, `refund_ids` and `chargeback_ids` has been removed
* All amounts have been changed to the `amount` type. Note that the `costs.amount`* fields can have more decimals than you would expect. The same goes for `rate.fixed`, which can contain fractional cents.
* `amount.net`, `amount.vat` and `amount.gross` have been moved one level up as `amount_net`, `amount_vat` and `amount_gross`

## Changes in the Mandates API

The following fields have been changed, renamed or moved:

* `created_datetime` has been renamed to `created_at`

## Changes in the Organizations API

The fields `country`, `registration_date` and `registration_type` have been removed.
The field `address` is now an `OpenStruct` with address details. See
[Address object](https://docs.mollie.com/guides/common-data-types#address-object).

## Changes in the Permissions API

The field `warning` has been removed.

## Changes in the Invoice API

* `issued_date` has been renamed to `issued_at`
* `paid_date` has been renamed to `paid_at`
* `due_date` has been renamed to `due_at`
* `amount.net`, `amount.vat` and `amount.gross` have been moved one level up as
`amount_net`, `amount_vat` and `amountGross`

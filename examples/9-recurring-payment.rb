require 'sinatra'
require "net/https"
require File.expand_path "../lib/mollie/api/client", File.dirname(__FILE__)

get '/start_payment' do
  client = Mollie::API::Client.new("test_xxxxxxxxxxxxx")
  customer = client.customers.create
  mollie_payment = client.customers_payments
    .with(customer).create({
        amount:        0.01,
        description:   'Set up billing',
        recurringType: 'first',
        redirectUrl:   "https://xxxxxx.ngrok.io/after_payment",
        webhookUrl:    "https://xxxxxx.ngrok.io/web_hook"
  })
  redirect mollie_payment.payment_url
end

get '/after_payment' do
  payment_id = params['id']
  client = Mollie::API::Client.new("test_xxxxxxxxxxxxx")
  client.payments.get(payment_id)
end

post '/web_hook' do
  payment_id = params['id']
  client = Mollie::API::Client.new("test_xxxxxxxxxxxxx")
  puts client.payments.get(payment_id).attributes
end

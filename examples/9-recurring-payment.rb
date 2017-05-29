require 'sinatra'
require "net/https"
require File.expand_path "../lib/mollie/api/client", File.dirname(__FILE__)

set :protection, :except => [:json_csrf]
enable :sessions

get '/' do
  client                = Mollie::API::Client.new("test_xxxxxxxxxx")
  customer              = client.customers.create
  mollie_payment        = client.customers_payments
      .with(customer).create({
                                 amount:        0.01,
                                 description:   'Set up billing',
                                 recurringType: 'first',
                                 redirectUrl:   "https://xxxxxx.ngrok.io/after_payment",
                                 webhookUrl:    "https://xxxxxx.ngrok.io/web_hook"
                             })
  session[:customer_id] = customer.id
  session[:payment_id]  = mollie_payment.id
  redirect mollie_payment.payment_url
end

get '/after_payment' do
  client  = Mollie::API::Client.new("test_xxxxxxxxxx")
  payment = client.payments.get(session[:payment_id])

  content_type :json
  JSON.pretty_generate(payment.attributes)
end

post '/web_hook' do
  payment_id = params['id']
  client     = Mollie::API::Client.new("test_xxxxxxxxxx")
  payment    = client.payments.get(payment_id)
  JSON.pretty_generate(payment.attributes)

  status :no_content
  nil
end

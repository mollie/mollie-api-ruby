require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/namespace'
require 'sinatra/cross_origin'
require "swagger/blocks"

require File.expand_path "../lib/mollie/api/client", File.dirname(__FILE__)

class Application < Sinatra::Application
  include Swagger::Blocks

  before do
    headers "Access-Control-Allow-Origin" => "*"
    headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, X-Mollie-Api-Key"
  end

  configure :production, :development do
    register Sinatra::Reloader
    register Sinatra::CrossOrigin
    register Sinatra::Namespace
    enable :cross_origin
    enable :logging
    set :show_exceptions, false
    set :static, true

    also_reload File.expand_path "./apis/*.rb", File.dirname(__FILE__)
  end

  error {|err| Rack::Response.new([{ 'error' => err.message }.to_json], 500, { 'Content-type' => 'application/json' }).finish}

  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"

    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, X-Mollie-Api-Key"

    200
  end

  def client
    @client ||= Mollie::API::Client.new(request.env["HTTP_X_MOLLIE_API_KEY"] || ENV["API_KEY"])
  end

  def json_params
    @json_params ||= JSON.parse request.body.read
  end

end

Dir[File.join('apis', '*.rb')].each {|file| require File.expand_path(file)}

run Application.new



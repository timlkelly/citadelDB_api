require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'honeybadger' if ENV['HONEYBADGER_API_KEY'].present?
require 'will_paginate'
require 'will_paginate/active_record'
require './config/environments'
require './models/citadel'
require './models/killmail'
require './models/system'
require './models/region'
require './lib/api_pagination'
require_relative 'lib/killmail_integration'

register ::Sinatra::Pagination

get '/' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  content_type :json
  ({ citadels: paginate(Citadel).map(&:api_hash) }).to_json
end

options '/' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Methods'] = 'GET'
  response.headers['Access-Control-Allow-Headers'] = 'Access-Control-Allow-Origin'
end

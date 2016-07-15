require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cross_origin'
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
  content_type :json
  ({ citadels: paginate(Citadel).map(&:api_hash) }).to_json
end

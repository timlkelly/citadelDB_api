require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/citadel'
require './models/killmail'
require './models/system'
require './models/region'
require_relative 'lib/killmail_integration'

get '/' do
  # return paginated list of citadels
  # return in json
  # killed_at integer
  # only return needed after
  content_type :json
  return Citadel.first.to_json
end

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
end

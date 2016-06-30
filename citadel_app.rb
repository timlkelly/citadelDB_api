require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/citadel'
require './models/killmail'
require_relative 'lib/parser'

get '/' do
end

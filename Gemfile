source 'https://rubygems.org'

ruby '2.2.5'

gem 'sinatra'
gem 'pg'
gem 'rake'
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'activesupport'
gem 'httparty'
gem 'will_paginate'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'

group :production do
  gem 'honeybadger'
end

group :development, :test do
  gem 'rspec'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'shotgun'
end

group :test do
  gem 'rack-test', require: 'rack/test'
  gem 'codeclimate-test-reporter', require: nil
end
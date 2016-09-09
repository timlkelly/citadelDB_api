require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'rack/test'
require 'rspec'
require 'pp'

ENV['RACK_ENV'] ||= 'test'

require_relative '../citadel_app.rb'

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end

module WithRollback
  def temporarily(&block)
    ActiveRecord::Base.connection.transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end
end

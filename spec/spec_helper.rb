require 'rack/test'
require 'rspec'
require 'pp'
require_relative '../citadel_app.rb'

ENV['RACK_ENV'] ||= 'test'

RSpec.configure do |c|
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
      block.call
      raise ActiveRecord::Rollback
    end
  end
end

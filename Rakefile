require 'bundler/gem_helper'
# require 'rspec/core/rake_task'
require './citadel_app'
require 'sinatra/activerecord/rake'

# desc 'Run all specs'
# RSpec::Core::RakeTask.new(:spec) do |t|
#   t.rspec_opts = %w(--color)
#   t.verbose = false
# end

begin
  require 'rspec/core/rake_task'
  desc 'Run all specs'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w(--color)
    t.verbose = false
  end
rescue LoadError
end

task default: :spec

namespace :fetch do
  desc "Listens to zKillboard's listen service"
  task :listen do
    puts 'listening...'
    KillmailIntegration.new.listen
    puts 'complete'
  end

  desc 'Pull past killmails'
  task :pull do
    puts 'pulling mails...'
    KillmailIntegration.new.json_to_killmail
    puts 'complete'
  end
end

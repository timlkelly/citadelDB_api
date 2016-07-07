require 'bundler/gem_helper'
# require 'rspec/core/rake_task'
require './citadel_app'
require 'sinatra/activerecord/rake'
require 'pp'

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
    log = ActiveSupport::Logger.new('./log/listen_service.log')
    start_time = Time.now
    citadel_count = Citadel.count
    killmail_count = Killmail.count
    log.info "Listen task started at #{start_time}."
    
    t = KillmailIntegration.new
    b = Killmail.new(killmail_json: t.fetch_killmail)
    pp t.parse_killmail
    # pp b.killmail_data
    # pp b.killmail_data['killmail']['victim']['shipType']['name']

    end_time = Time.now
    duration = (start_time - end_time) / 1.minute
    log.info "Task finished at #{end_time} and last #{duration} minutes."
    log.close
    put 'complete'
  end

  desc 'Pull past killmails'
  task :pull do
    puts 'pulling mails...'
    KillmailIntegration.new.json_to_killmail
    puts 'complete'
  end
end

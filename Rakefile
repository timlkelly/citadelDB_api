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
    # log = ActiveSupport::Logger.new('./log/listen_service.log')
    # start_time = Time.now
    # log.info 'Begin log:'
    # log.info "Listen task started at #{start_time}."
    KillmailIntegration.new.parse_killmail
    # citadel_count = Citadel.count
    # killmail_count = Killmail.count
    # end_time = Time.now
    # duration = (start_time - end_time) / 1.minute
    # log.info "Task finished at #{end_time} and took #{duration} minute(s)."
    # log.close
    puts 'complete'
  end

  desc 'Pull past killmails'
  task :pull do
    puts 'pulling mails...'
    # log = ActiveSupport::Logger.new('./log/pull_task.log')
    # start_time = Time.now
    # log.info 'Begin log:'
    # log.info "Pull task started at #{start_time}"
    # citadel_count = Citadel.count
    # killmail_count = Killmail.count
    # log.info 'Counts before task'
    # log.info "Citadels: #{citadel_count}"
    # log.info "Killmails: #{killmail_count}"
    KillmailIntegration.new.json_to_killmail
    # citadel_count = Citadel.count
    # killmail_count = Killmail.count
    # log.info 'Counts after task'
    # log.info "Citadels: #{citadel_count}"
    # log.info "Killmails: #{killmail_count}"
    # end_time = Time.now
    # duration = (start_time - end_time) / 1.minute
    # log.info "Task finished at #{end_time} and took #{duration} minute(s)"
    # log.close
    puts 'complete'
  end
end

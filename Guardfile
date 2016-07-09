group :red_green_refactor, halt_on_fail: true do
  guard :rspec, failed_mode: :focus, cmd: 'bundle exec rspec' do
    watch('citadel_app.rb')     { |m| "spec/citadel_app_spec.rb" }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^models/(.+)\.rb$})  { |m| "spec/models/#{m[1]}_spec.rb" }
  end

  guard :rubocop, all_on_start: false do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end

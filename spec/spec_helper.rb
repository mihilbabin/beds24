require 'bundler/setup'
require 'webmock/rspec'
require 'simplecov'

require_relative './helpers'

SimpleCov.start do
  add_filter "/spec/"
end

RSPEC_ROOT = File.dirname __FILE__

require 'beds24'
Dir[File.join(Dir.pwd, 'spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Helpers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

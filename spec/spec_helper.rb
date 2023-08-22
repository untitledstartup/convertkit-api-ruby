require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  enable_coverage :branch
end

require 'convertkit'

RSpec.configure do |config|
  config.mock_with :rspec
end

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  enable_coverage :branch
end

require 'convertkit'
# require 'spec/validators/tags_validators'

Dir['spec/validators/**/*.rb'].sort.each { |file| require Pathname.new(file).relative_path_from('spec').to_s }

RSpec.configure do |config|
  config.mock_with :rspec

end

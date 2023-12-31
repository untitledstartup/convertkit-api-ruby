require_relative 'lib/convertkit/version'

Gem::Specification.new do |gem|
  gem.name        = 'convertkit-api-ruby'
  gem.version     = ConvertKit::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['Mighty Networks']
  gem.homepage    = 'https://github.com/untitledstartup/convertkit-api-ruby'

  gem.summary     = 'Ruby SDK for invoking the ConvertKit API'
  gem.license     = 'MIT'
  gem.files       = Dir['{lib}/**/*.rb']

  gem.add_dependency 'faraday', ['>= 1.0', '< 3.0']

  # tests
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'simplecov', '~> 0.2'
end

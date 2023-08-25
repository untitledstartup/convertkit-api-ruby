require 'convertkit/resources/account'
require 'convertkit/access_token_response'
require 'convertkit/client'
require 'convertkit/connection_helper'
require 'convertkit/error'
require 'convertkit/oauth'
require 'convertkit/version'

module ConvertKit

  class << self
    def version
      ConvertKit::VERSION
    end
  end
end

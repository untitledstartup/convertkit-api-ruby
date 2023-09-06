require 'convertkit/access_token_response'
require 'convertkit/client'
require 'convertkit/connection'
require 'convertkit/error'
require 'convertkit/oauth'
require 'convertkit/resources/account'
require 'convertkit/resources/custom_fields'
require 'convertkit/resources/custom_field_response'
require 'convertkit/resources/sequence_response'
require 'convertkit/resources/sequences'
require 'convertkit/resources/subscriber_response'
require 'convertkit/resources/subscribers'
require 'convertkit/resources/subscribers_response'
require 'convertkit/resources/subscription_response'
require 'convertkit/resources/subscriptions_response'
require 'convertkit/resources/tags'
require 'convertkit/resources/tag_response'
require 'convertkit/utils'
require 'convertkit/version'

module ConvertKit

  class << self
    def version
      ConvertKit::VERSION
    end
  end
end

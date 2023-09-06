require 'convertkit/access_token_response'
require 'convertkit/client'
require 'convertkit/connection'
require 'convertkit/error'
require 'convertkit/oauth'
require 'convertkit/resources/account'
require 'convertkit/resources/broadcast_response'
require 'convertkit/resources/broadcast_stats_response'
require 'convertkit/resources/broadcasts'
require 'convertkit/resources/subscriber_response'
require 'convertkit/resources/tags'
require 'convertkit/resources/tag_response'
require 'convertkit/resources/tag_subscription_response'
require 'convertkit/resources/tag_subscriptions_response'
require 'convertkit/utils'
require 'convertkit/version'

module ConvertKit

  class << self
    def version
      ConvertKit::VERSION
    end
  end
end

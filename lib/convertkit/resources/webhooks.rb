module ConvertKit
  module Resources
    class Webhooks
      PATH = 'automations/hooks'.freeze

      def initialize(client)
        @client = client
      end

      # Create a webhook that will be called when a subscriber event occurs
      # See https://developers.convertkit.com/#create-a-webhook for details
      # @param [String] target_url Url to receive the subscriber data when an event occurs
      # @param [Hash] event JSON object containing the event name and extra information when applicable
      def create_webhook(target_url, event)
        request_params = {
          target_url: target_url,
          event: event
        }

        response = @client.post(PATH, request_params)
        ConvertKit::Resources::WebhookRuleResponse.new(response)
      end
    end
  end
end

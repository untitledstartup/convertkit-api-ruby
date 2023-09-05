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
      def create(target_url, event)
        request_params = {
          target_url: target_url,
          event: event
        }

        response = @client.post(PATH, request_params)
        ConvertKit::Resources::WebhookRuleResponse.new(response)
      end

      # Delete a webhook
      # See https://developers.convertkit.com/#destroy-webhook for details
      # @param [Integer] rule_id
      def delete(rule_id)
        response = @client.delete("#{PATH}/#{rule_id}")

        response.fetch('success', false)
      end
    end
  end
end

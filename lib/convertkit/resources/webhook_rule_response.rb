module ConvertKit
  module Resources
    class WebhookRuleResponse
      attr_reader :id, :account_id, :event, :target_url

      def initialize(response)
        @id = response['id']
        @account_id = response['account_id']
        @target_url = response['target_url']
        @event = ConvertKit::Resources::EventResponse.new(response['event']) if response['event']
      end
    end
  end
end

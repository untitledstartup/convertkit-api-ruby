module ConvertKit
  module Resources
    class WebhookRuleResponse
      attr_reader :id, :account_id, :event, :target_url

      def initialize(values)
        @id = values['id']
        @account_id = values['account_id']
        @target_url = values['target_url']
        @event = ConvertKit::Resources::EventResponse.new(values['event']) if values['event']
      end
    end
  end
end

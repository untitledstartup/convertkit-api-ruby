describe ConvertKit::Resources::WebhookRuleResponse do
  include Validators::WebhookValidators

  describe '#initialize' do
    it 'sets the id and account_id' do
      response = { 'id' => 1, 'account_id' => 2 }
      webhook_rule_response = ConvertKit::Resources::WebhookRuleResponse.new(response)
      validate_webhook_rule(webhook_rule_response, response)
    end

    it 'sets the name,  and sequence_id' do
      response = {
        'id' => 1,
        'account_id' => 2,
        'target_url' => 'https://test.com',
        'event' => { 'name' => 'subscriber_activate', 'sequence_id' => 1 }
      }
      webhook_rule_response = ConvertKit::Resources::WebhookRuleResponse.new(response)
      validate_webhook_rule(webhook_rule_response, response)
    end
  end
end

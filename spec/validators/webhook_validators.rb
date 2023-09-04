module Validators
  module WebhookValidators

    def validate_event(event, values)
      expect(event.name).to eq(values['name'])
      expect(event.sequence_id).to eq(values['sequence_id'])
    end

    def validate_webhook_rule(webhook_rule, values)
      expect(webhook_rule.id).to eq(values['id'])
      expect(webhook_rule.account_id).to eq(values['account_id'])
      expect(webhook_rule.target_url).to eq(values['target_url'])
      validate_event(webhook_rule.event, values['event']) if values['event']
    end
  end
end

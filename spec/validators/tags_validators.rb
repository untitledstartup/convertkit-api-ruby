module Validators
  module TagsValidators
    def validate_tag(tag, values)
      expect(tag.id).to eq(values['id'])
      expect(tag.name).to eq(values['name'])
      expect(tag.account_id).to eq(values['account_id'])
      expect(tag.state).to eq(values['state'])

      expect(tag.created_at).to eq(DateTime.parse(values['created_at'])) unless values.fetch('created_at', '').strip.empty?
      expect(tag.updated_at).to eq(DateTime.parse(values['updated_at'])) unless values.fetch('updated_at', '').strip.empty?
      expect(tag.deleted_at).to eq(DateTime.parse(values['deleted_at'])) unless values.fetch('deleted_at', '').strip.empty?
    end

    def validate_tags(tags, values)
      tags.each_with_index do |tag, index|
        validate_tag(tag, values[index])
      end
    end

    def validate_tag_subscription(subscription, value)
      expect(subscription.id).to eq(value['id'])
      expect(subscription.state).to eq(value['state'])
      expect(subscription.source).to eq(value['source'])
      expect(subscription.referrer).to eq(value['referrer'])
      expect(subscription.subscribable_id).to eq(value['subscribable_id'])
      expect(subscription.subscribable_type).to eq(value['subscribable_type'])
      expect(subscription.subscriber_id).to eq(value.dig('subscriber', 'id'))
      expect(subscription.created_at).to eq(DateTime.parse(value['created_at'])) unless value.fetch('created_at', '').strip.empty?
    end
  end
end

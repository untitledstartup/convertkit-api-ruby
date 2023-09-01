module Validators
  module TagsValidator
    include Validators::SubscriberValidators

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

    def validate_tag_subscription(tag_subscription, value)
      expect(tag_subscription.id).to eq(value['id'])
      expect(tag_subscription.state).to eq(value['state'])
      expect(tag_subscription.source).to eq(value['source'])
      expect(tag_subscription.referrer).to eq(value['referrer'])
      expect(tag_subscription.subscribable_id).to eq(value['subscribable_id'])
      expect(tag_subscription.subscribable_type).to eq(value['subscribable_type'])
      expect(tag_subscription.created_at).to eq(DateTime.parse(value['created_at'])) unless value.fetch('created_at', '').strip.empty?
      validate_subscriber(tag_subscription.subscriber, value['subscriber']) if value['subscriber']
    end

    def validate_tag_subscriptions(tag_subscriptions, values)
      expect(tag_subscriptions.total_subscriptions).to eq(values['total_subscriptions'])
      expect(tag_subscriptions.page).to eq(values['page'])
      expect(tag_subscriptions.total_pages).to eq(values['total_pages'])

      tag_subscriptions.subscriptions.each_with_index do |tag_subscription, index|
        validate_tag_subscription(tag_subscription, values['subscriptions'][index])
      end
    end
  end
end

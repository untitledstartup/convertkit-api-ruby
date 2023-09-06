module Validators
  module SubscriptionValidators
    include Validators::SubscriberValidators
    def validate_subscription(subscription, value)
      expect(subscription.id).to eq(value['id'])
      expect(subscription.state).to eq(value['state'])
      expect(subscription.source).to eq(value['source'])
      expect(subscription.referrer).to eq(value['referrer'])
      expect(subscription.subscribable_id).to eq(value['subscribable_id'])
      expect(subscription.subscribable_type).to eq(value['subscribable_type'])
      expect(subscription.created_at).to eq(DateTime.parse(value['created_at'])) unless value.fetch('created_at', '').strip.empty?
      validate_subscriber(subscription.subscriber, value['subscriber']) if value['subscriber']
    end

    def validate_subscriptions(subscriptions, values)
      expect(subscriptions.total_subscriptions).to eq(values['total_subscriptions'])
      expect(subscriptions.page).to eq(values['page'])
      expect(subscriptions.total_pages).to eq(values['total_pages'])

      subscriptions.subscriptions.each_with_index do |subscription, index|
        validate_subscription(subscription, values['subscriptions'][index])
      end
    end
  end
end

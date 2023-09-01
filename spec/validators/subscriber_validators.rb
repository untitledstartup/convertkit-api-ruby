module Validators
  module SubscriberValidators
    def validate_subscriber(subscriber, values)
      expect(subscriber.id).to eq(values['id'])
      expect(subscriber.first_name).to eq(values['first_name'])
      expect(subscriber.email).to eq(values['email_address'])
      expect(subscriber.state).to eq(values['state'])
      expect(subscriber.fields).to match(values['fields'])
      expect(subscriber.created_at).to eq(DateTime.parse(values['created_at'])) unless values.fetch('created_at', '').strip.empty?
    end

    def validate_subscribers(subscribers, values)
      expect(subscribers.total_subscribers).to eq(values['total_subscribers'])
      expect(subscribers.page).to eq(values['page'])
      expect(subscribers.total_pages).to eq(values['total_pages'])

      subscribers.subscribers.each_with_index do |subscriber, index|
        validate_subscriber(subscriber, values['subscribers'][index])
      end
    end
  end
end

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

    def validate_bulk_create_failure(bulk_create_failure_response, values)
      expect(bulk_create_failure_response.errors).to match_array(values['errors']) if values['errors']
      validate_subscriber(bulk_create_failure_response.subscriber, values['subscriber']) if values['subscriber']
    end

    def validate_bulk_create(bulk_create_response, values)
      bulk_create_response.subscribers.each_with_index do |subscriber, index|
        validate_subscriber(subscriber, values['subscribers'][index])
      end

      bulk_create_response.failures.each_with_index do |failure, index|
        validate_bulk_create_failure(failure, values['failures'][index])
      end
    end
  end
end

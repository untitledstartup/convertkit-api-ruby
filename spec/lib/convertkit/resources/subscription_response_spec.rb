describe ConvertKit::Resources::SubscriptionResponse do
  include Validators::SubscriptionValidators

  describe '#initialize' do
    it 'sets the id and state' do
      response = { 'id' => 1, 'state' => 'active'}
      subscription_response = ConvertKit::Resources::SubscriptionResponse.new(response)
      validate_subscription(subscription_response, response)
    end

    it 'sets the id, state, source, referrer, subscribable_id, subscribable_type, subscriber_id, created_at' do
      response = {
        'id' => 2,
        'state' => 'active',
        'source' => 'source',
        'referrer' => 'referrer',
        'subscribable_id' => 1,
        'subscribable_type' => 'tag',
        'created_at' => '2023-08-09T04:30:00Z',
        'subscriber' => { 'id' => 4}
      }
      subscription_response = ConvertKit::Resources::SubscriptionResponse.new(response)
      validate_subscription(subscription_response, response)
    end
  end
end

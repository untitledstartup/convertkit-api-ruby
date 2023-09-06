describe ConvertKit::Resources::SubscriptionsResponse do
  include Validators::SubscriptionValidators

  describe '#initialize' do
    it 'set with an empty list of subscriptions' do
      response = { 'total_subscriptions' => 0, 'page' => 1, 'total_pages' => 1, 'subscriptions' => [] }
      subscriptions_response = ConvertKit::Resources::SubscriptionsResponse.new(response)
      validate_subscriptions(subscriptions_response, response)
    end

    it 'set with a list of subscriptions' do
      response = {
        'total_subscriptions' => 2,
        'page' => 1,
        'total_pages' => 1,
        'subscriptions' => [
          {
            'id' => 2,
            'state' => 'active',
            'source' => 'source',
            'referrer' => 'referrer',
            'subscribable_id' => 1,
            'subscribable_type' => 'tag',
            'created_at' => '2023-08-09T04:30:00Z',
            'subscriber' => { 'id' => 1}
          },
          {
            'id' => 3,
            'state' => 'active',
            'source' => 'source',
            'referrer' => 'referrer',
            'subscribable_id' => 1,
            'subscribable_type' => 'tag',
            'created_at' => '2023-08-09T04:30:00Z',
            'subscriber' => { 'id' => 2}
          }
        ]
      }
      subscriptions_response = ConvertKit::Resources::SubscriptionsResponse.new(response)
      validate_subscriptions(subscriptions_response, response)
    end
  end
end

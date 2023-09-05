describe ConvertKit::Resources::TagSubscriptionResponse do
  include Validators::TagValidators

  describe '#initialize' do
    it 'sets the id and state' do
      response = { 'id' => 1, 'state' => 'active'}
      tag_response = ConvertKit::Resources::TagSubscriptionResponse.new(response)
      validate_tag_subscription(tag_response, response)
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
      tag_response = ConvertKit::Resources::TagSubscriptionResponse.new(response)
      validate_tag_subscription(tag_response, response)
    end
  end
end

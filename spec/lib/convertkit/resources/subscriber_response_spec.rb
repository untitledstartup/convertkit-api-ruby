describe ConvertKit::Resources::SubscriberResponse do
  include Validators::SubscriberValidators

  describe '#initialize' do
    it 'sets the id, first_name, email and state' do
      response = { 'id' => 1, 'first_name' => 'test_user', 'email' => 'test@test.com', 'state' => 'active'}
      subscriber_response = ConvertKit::Resources::SubscriberResponse.new(response)
      validate_subscriber(subscriber_response, response)
    end

    it 'sets the id, first_name, email, state, fields,  and created_at' do
      response = {
        'id' => 1,
        'first_name' => 'test_user',
        'email' => 'test@test.com',
        'state' => 'active',
        'fields' => { 'field_key' => 'field_value' },
        'created_at' => '2023-08-09T04:30:00Z'
      }
      subscriber_response = ConvertKit::Resources::SubscriberResponse.new(response)
      validate_subscriber(subscriber_response, response)
    end
  end
end

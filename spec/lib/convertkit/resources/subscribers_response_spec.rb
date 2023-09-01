describe ConvertKit::Resources::SubscribersResponse do
  include Validators::SubscriberValidators

  describe '#initialize' do
    it 'set with an empty list of subscribers' do
      response = { 'total_subscribers' => 0, 'page' => 1, 'total_pages' => 1, 'subscribers' => [] }
      tag_response = ConvertKit::Resources::SubscribersResponse.new(response)
      validate_subscribers(tag_response, response)
    end

    it 'set with a list of subscribers' do
      response = {
        'total_subscribers' => 2,
        'page' => 1,
        'total_pages' => 1,
        'subscribers' => [
          {
            'id' => 2,
            'first_name' => 'subscriber1_first_name',
            'email_address' => 'testa@test.com',
            'state' => 'active',
            'created_at' => '2023-08-09T04:30:00Z',
            'fields' => { 'last_name' => 'subscriber1_last_name' }
          },
          {
            'id' => 3,
            'first_name' => 'subscriber2_first_name',
            'email_address' => 'testb@test.com',
            'state' => 'active',
            'created_at' => '2023-08-11T04:30:00Z',
            'fields' => { 'last_name' => 'subscriber2_last_name' }
          }
        ]
      }
      tag_response = ConvertKit::Resources::SubscribersResponse.new(response)
      validate_subscribers(tag_response, response)
    end
  end
end

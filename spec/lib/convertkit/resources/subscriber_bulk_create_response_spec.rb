describe ConvertKit::Resources::SubscriberBulkCreateResponse do
  include Validators::SubscriberValidators

  describe '#initialize' do
    it 'sets the subscribers' do
      response = {
        'subscribers' => [{ 'id' => 1, 'first_name' => 'test_user', 'email' => 'test@test.com', 'state' => 'active'}],
        'failures' => []
      }

      bulk_create_response = ConvertKit::Resources::SubscriberBulkCreateResponse.new(response)
      validate_bulk_create(bulk_create_response, response)
    end

    it 'sets the failures' do
      response = {
        'subscribers' => [],
        'failures' => [
          {
            subscriber: { 'first_name' => 'test_user' },
            errors: ['Email address cannot be blank', 'Email address is invalid']
          }
        ]
      }

      bulk_create_response = ConvertKit::Resources::SubscriberBulkCreateResponse.new(response)
      validate_bulk_create(bulk_create_response, response)
    end

    it 'sets the failures with subscriber data missing' do
      response = {
        'subscribers' => [],
        'failures' => [
          {
            errors: ['Email address cannot be blank', 'Email address is invalid']
          }
        ]
      }

      bulk_create_response = ConvertKit::Resources::SubscriberBulkCreateResponse.new(response)
      validate_bulk_create(bulk_create_response, response)
    end

    it 'sets the subscribers and failures' do
      response = {
        'subscribers' => [{ 'id' => 1, 'first_name' => 'test_user', 'email' => 'test@test.com', 'state' => 'active'}],
        'failures' => [
          {
            subscriber: { 'first_name' => 'test_user'},
            errors: ['Email address cannot be blank', 'Email address is invalid']
          }
        ]
      }

      bulk_create_response = ConvertKit::Resources::SubscriberBulkCreateResponse.new(response)
      validate_bulk_create(bulk_create_response, response)
    end
  end
end

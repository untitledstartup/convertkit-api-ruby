describe ConvertKit::Resources::BroadcastResponse do
  include Validators::BroadcastValidators

  describe '#initialize' do
    it 'sets the id, subject and content' do
      response = {
        'id' => 1,
        'subject' => 'Welcome to the test newsletter',
        'created_at' => '2023-09-05T00:00:00Z'
      }
      broadcast_response = ConvertKit::Resources::BroadcastResponse.new(response)
      validate_broadcast(broadcast_response, response)
    end

    it 'sets all the attributes of a broadcast response' do
      response = {
        'id' => 1,
        'subject' => 'Welcome to the test newsletter',
        'description' => 'A weekly newsletter for testing',
        'content' => 'This is the content of the newsletter',
        'public' => true,
        'email_address' => 'test@test.com',
        'email_layout_template' => 'Text Only',
        'thumbnail_url' => 'https://test.com/test.png',
        'thumbnail_alt' => 'Test Image',
        'created_at' => '2023-09-05T00:00:00Z',
        'published_at' => '2023-09-05T00:00:00Z',
        'send_at' => '2023-09-05T00:00:00Z'
      }
      broadcast_response = ConvertKit::Resources::BroadcastResponse.new(response)
      validate_broadcast(broadcast_response, response)
    end
  end
end

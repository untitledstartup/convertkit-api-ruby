describe ConvertKit::Resources::Broadcasts do
  include Validators::BroadcastValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      broadcasts = ConvertKit::Resources::Broadcasts.new(client)
      expect(broadcasts.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#list' do
    let(:broadcasts) { ConvertKit::Resources::Broadcasts.new(client) }

    it 'return a list of broadcasts' do
      response = {
        'broadcasts' => [
          {'id' => 1, 'subject' => 'Test Broadcast 1', 'created_at' => '2023-09-05T00:00:00Z'},
          {'id' => 2, 'subject' => 'Test Broadcast 2', 'created_at' => '2023-09-06T00:00:00Z'}
        ]
      }

      expect(client).to receive(:get).with('broadcasts', {}).and_return(response)
      broadcast_responses = broadcasts.list
      validate_broadcasts(broadcast_responses, response['broadcasts'])
    end
  end

  describe '#create' do
    let(:broadcasts) { ConvertKit::Resources::Broadcasts.new(client) }

    it 'creates a broadcast' do
      response = {
        'id' => 1,
        'subject' => 'Test Broadcast 1',
        'description' => 'A weekly newsletter for testing',
        'content' => 'This is the content of the newsletter',
        'public' => true,
        'email_address' => 'test@test.com',
        'email_layout_template' => 'Text Only',
        'thumbnail_url' => 'https://test.com/test.png',
        'thumbnail_alt' => 'Test Image',
        'created_at' => '2023-09-05T00:00:00Z',
        'published_at' => '2023-09-06T00:00:00Z',
        'send_at' => '2023-09-06T00:00:00Z',
      }

      request = {
        content: 'This is the content of the newsletter',
        subject: 'Test Broadcast 1',
        public: true
      }

      expect(client).to receive(:post).with('broadcasts', request).and_return(response)
      broadcast_response = broadcasts.create(request)
      validate_broadcast(broadcast_response, response)
    end
  end

  describe '#get' do
    let(:broadcasts) { ConvertKit::Resources::Broadcasts.new(client) }

    it 'retrieves a broadcast' do
      response = {
        'id' => 1,
        'subject' => 'Test Broadcast 1',
        'description' => 'A weekly newsletter for testing',
        'content' => 'This is the content of the newsletter',
        'public' => true,
        'email_address' => 'test@test.com',
        'email_layout_template' => 'Text Only',
        'thumbnail_url' => 'https://test.com/test.png',
        'thumbnail_alt' => 'Test Image',
        'created_at' => '2023-09-05T00:00:00Z',
        'published_at' => '2023-09-06T00:00:00Z',
        'send_at' => '2023-09-06T00:00:00Z',
      }

      expect(client).to receive(:get).with('broadcasts/1').and_return(response)
      broadcast_response = broadcasts.get(1)
      validate_broadcast(broadcast_response, response)
    end
  end
end

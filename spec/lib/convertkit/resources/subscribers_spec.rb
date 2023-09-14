describe ConvertKit::Resources::Subscribers do
  include Validators::SubscriberValidators
  include Validators::TagValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      account = ConvertKit::Resources::Subscribers.new(client)
      expect(account.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#list' do
    let(:subscribers) { ConvertKit::Resources::Subscribers.new(client) }

    it 'returns a list of subscribers' do
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
      expect(client).to receive(:get).with('subscribers', {}).and_return(response)
      subscribers_response = subscribers.list
      validate_subscribers(subscribers_response, response)
    end
  end

  describe '#get' do
    let(:subscribers) { ConvertKit::Resources::Subscribers.new(client) }

    it 'returns a subscriber' do
      response = {
        'id' => 1,
        'first_name' => 'subscriber_first_name',
        'email_address' => 'test@test.com',
        'state' => 'active',
        'created_at' => '2023-08-09T04:30:00Z',
        'fields' => { 'last_name' => 'subscriber_last_name' }
      }
      expect(client).to receive(:get).with('subscribers/1').and_return(response)
      subscriber_response = subscribers.get(1)
      validate_subscriber(subscriber_response, response)
    end
  end

  describe '#create' do
    let(:subscribers) { ConvertKit::Resources::Subscribers.new(client) }

    it 'creates a subscriber with just an email' do
      response = {
        'subscriber' => {
          'id' => 1,
          'first_name' => nil,
          'email_address' => 'test@test.com',
          'state' => 'active',
          'fields' => {},
        }
      }

      expect(client).to receive(:post).with('subscribers', { email_address: 'test@test.com' }).and_return(response)
      subscriber_response = subscribers.create('test@test.com')
      validate_subscriber(subscriber_response, response['subscriber'])
    end

    it 'creates a subscriber with an email and first name' do
      response = {
        'subscriber' => {
          'id' => 1,
          'first_name' => 'test first name',
          'email_address' => 'test@test.com',
          'state' => 'active',
          'fields' => {},
        }
      }

      expect(client).to receive(:post).with('subscribers', { email_address: 'test@test.com', first_name: 'test first name' }).and_return(response)
      subscriber_response = subscribers.create('test@test.com', { first_name: 'test first name' })
      validate_subscriber(subscriber_response, response['subscriber'])
    end
  end

  describe '#update' do
    let(:subscribers) { ConvertKit::Resources::Subscribers.new(client) }

    it 'updates a subscriber' do
      response = {
        'subscriber' => {
          'id' => 1,
          'first_name' => 'updated_first_name',
          'email_address' => 'test@test.com',
          'state' => 'active',
          'created_at' => '2023-08-09T04:30:00Z',
          'fields' => { 'last_name' => 'subscriber_last_name' }
        }
      }
      expect(client).to receive(:put).with('subscribers/1', { first_name: 'updated_first_name' }).and_return(response)
      subscriber_response = subscribers.update(1, { first_name: 'updated_first_name' })
      validate_subscriber(subscriber_response, response['subscriber'])
    end
  end

  describe '#unsubscribe' do
    let(:subscribers) { ConvertKit::Resources::Subscribers.new(client) }

    it 'updates a subscriber' do
      response = {
        'id' => 1,
        'first_name' => 'first_name',
        'email_address' => 'test@test.com',
        'state' => 'active',
        'created_at' => '2023-08-09T04:30:00Z',
        'fields' => { 'last_name' => 'subscriber_last_name' }
      }
      expect(client).to receive(:put).with('unsubscribe', { email: 'test@test.com' }).and_return(response)
      subscriber_response = subscribers.unsubscribe('test@test.com')
      validate_subscriber(subscriber_response, response)
    end
  end

  describe '#list_tags' do
    let(:subscribers) { ConvertKit::Resources::Subscribers.new(client) }

    it 'returns a list of tags for a subscriber' do
      response = {
        'tags' => [
          {
            'id' => 2,
            'name' => 'tag1_name',
            'created_at' => '2023-08-09T04:30:00Z'
          },
          {
            'id' => 3,
            'name' => 'tag2_name',
            'created_at' => '2023-08-11T04:30:00Z'
          }
        ]
      }
      expect(client).to receive(:get).with('subscribers/1/tags').and_return(response)
      tags_response = subscribers.list_tags(1)
      validate_tags(tags_response, response['tags'])
    end
  end
end

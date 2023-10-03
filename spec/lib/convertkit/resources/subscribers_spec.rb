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
        "subscriber" =>  {
          'id' => 1,
          'first_name' => 'subscriber_first_name',
          'email_address' => 'test@test.com',
          'state' => 'active',
          'created_at' => '2023-08-09T04:30:00Z',
          'fields' => { 'last_name' => 'subscriber_last_name' }
        }
      }
      expect(client).to receive(:get).with('subscribers/1').and_return(response)
      subscriber_response = subscribers.get(1)
      validate_subscriber(subscriber_response, response['subscriber'])
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

  describe '#bulk_create' do
    let(:subscribers) { ConvertKit::Resources::Subscribers.new(client) }

    it 'raise an error when an array is not passed in' do
      expect { subscribers.bulk_create(nil) }.to raise_error(ArgumentError, 'subscribers must be an array')
      expect { subscribers.bulk_create('test') }.to raise_error(ArgumentError, 'subscribers must be an array')
      expect { subscribers.bulk_create(123) }.to raise_error(ArgumentError, 'subscribers must be an array')
      expect { subscribers.bulk_create({ email_address: 'test@test.com' }) }.to raise_error(ArgumentError, 'subscribers must be an array')
    end

    it 'creates a list of subscribers' do
      response = {
        'subscribers' => [
          {
            'id' => 1,
            'first_name' => 'john',
            'email_address' => 'john@test.com',
            'state' => 'active',
            'fields' => {},
          },
          {
            'id' => 2,
            'first_name' => 'jane',
            'email_address' => 'jane@test.com',
            'state' => 'active',
            'fields' => {},
          }
        ],
        'failures' => []
      }

      request = [
        { first_name: 'john', email_address: 'john@test.com' },
        { first_name: 'jane', email_address: 'jane@test.com' }
      ]

      expect(client).to receive(:post).with('bulk/subscribers', subscribers: request).and_return(response)
      bulk_create_response = subscribers.bulk_create(request)
      validate_bulk_create(bulk_create_response, response)
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
    let(:response) { double('response', success?: true) }

    it 'unsubscribes a subscriber' do
      expect(client).to receive(:post).with('subscribers/1/unsubscribe', "", true).and_return(response)
      expect(subscribers.unsubscribe(1)).to be(true)
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

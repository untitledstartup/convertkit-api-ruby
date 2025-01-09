describe ConvertKit::Resources::Tags do
  include Validators::TagValidators
  include Validators::SubscriptionValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      account = ConvertKit::Resources::Tags.new(client)
      expect(account.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#list' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }
    let(:created_at) { '2023-08-09T04:30:00Z'}
    let(:response) { { 'tags' => [
      {'id' => 1, 'name' => 'test_tag1', 'created_at' => created_at},
      {'id' => 2, 'name' => 'test_tag2', 'created_at' => ''}
    ]}}

    it 'calls the get method on the client' do
      expect(client).to receive(:get).with('tags').and_return(response)
      tags_response = tags.list
      validate_tags(tags_response, response['tags'])
    end
  end

  describe '#create' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }

    context 'when name is a string' do
      it 'creates a tag' do
        response = {'tag' => { 'id' => 1, 'name' => 'tag_name', account_id: 1, state: 'available', 'created_at' => '2023-08-09T04:30:00Z', updated_at: '2023-08-09T04:30:00Z'}}
        expect(client).to receive(:post).with('tags', {name: 'tag_name'}).and_return(response)
        tags_response = tags.create('tag_name')
        validate_tag(tags_response, response['tag'])
      end
    end
  end

  describe '#add_to_subscriber' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }
    let(:response) { double('response', body: '', success?: true) }

    it 'tags a subscriber by id' do
      expect(client).to receive(:post).with(
        'tags/1/subscribers/2',
        '',
        true
      ).and_return(response)

      subscription_response = tags.add_to_subscriber(1, 2)
      expect(subscription_response).to be(true)
    end
  end

  describe '#add_to_subscriber_by_email_address' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }
    let(:response) { double('response', body: '', success?: true) }

    it 'tags a subscriber by email' do
      expect(client).to receive(:post).with(
        'tags/1/subscribers',
        { email_address: 'test@test.com'},
        true
      ).and_return(response)

      subscription_response = tags.add_to_subscriber_by_email_address(1, 'test@test.com')
      expect(subscription_response).to be(true)
    end

    it 'tags a subscriber by email with subscriber id included' do
      expect(client).to receive(:post).with(
        'tags/1/subscribers',
        { email_address: 'test@test.com',
          id: 2
        },
        true
      ).and_return(response)

      subscription_response = tags.add_to_subscriber_by_email_address(1, 'test@test.com', {subscriber_id: 2})
      expect(subscription_response).to be(true)
    end
  end

  describe '#remove_from_subscriber' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }
    let(:response) { double('response', body: '', success?: true) }

    it 'removes a tag from a subscriber by id' do
      expect(client).to receive(:delete).with('tags/1/subscribers/3', '', true).and_return(response)

      expect(tags.remove_from_subscriber(1, 3)).to eq true
    end
  end

  describe '#remove_from_subscriber_by_email_address' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }
    let(:response) { double('response', body: '', success?: true) }

    it 'removes a tag from a subscriber by email' do
      expect(client).to receive(:delete).with('tags/1/subscribers', {email_address: 'test@test.com'}, true).and_return(response)

      expect(tags.remove_from_subscriber_by_email_address(1, 'test@test.com')).to eq true
    end
  end

  describe '#subscriptions' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }

    it 'returns a list of tag subscriptions' do
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
      expect(client).to receive(:get).with('tags/1/subscriptions', {}).and_return(response)
      tag_subscriptions_response = tags.subscriptions(1)
      validate_subscriptions(tag_subscriptions_response, response)
    end
  end

  describe '#bulk_add_to_subscribers' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }
    let(:taggings) { [{'tag_id' => 1, 'subscriber_id' => 1}] }
    let(:response) do
      {
        'subscribers' => [{
          'id' => 1,
          'first_name' => 'foo',
          'email_address' => 'foo@bar.com',
          'created_at' => '2023-08-09T04:30:00Z',
          'tagged_at' => '2023-08-09T04:30:00Z'
        }],
        'failures' => []
      }
    end

    context 'with taggings provided' do
      it 'tags listed subscribers' do
        expect(client).to receive(:post).with('bulk/tags/subscribers', {taggings: taggings}).and_return(response)

        tags_response = tags.bulk_add_to_subscribers(taggings)
        validate_tagged_subscribers(tags_response, response)
      end
    end

    # Failures are not well documented in the API documentation
    context 'with failures' do
      let(:response) do
        {
          'subscribers' => [],
          'failures' => [{
            'subscriber' => {
              'id' => 1,
              'first_name' => 'foo',
              'email_address' => 'foo@bar.com',
              'created_at' => '2023-08-09T04:30:00Z',
            },
            'errors' => ['Test error message']
          }]
        }
      end

      it 'return failures with subscriber and error message' do
        expect(client).to receive(:post).with('bulk/tags/subscribers', {taggings: taggings}).and_return(response)

        tags_response = tags.bulk_add_to_subscribers(taggings)
        expect(tags_response.failures.count).to eq(1)
        expect(tags_response.failures.first.subscriber.id).to eq(1)
        expect(tags_response.failures.first.errors.first).to eq('Test error message')
      end
    end
  end

  describe '#bulk_remove_from_subscribers' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }
    let(:taggings) { [{'tag_id' => 1, 'subscriber_id' => 1}] }
    let(:response) do
      {
        'failures' => []
      }
    end

    context 'with taggings provided' do
      it 'return no failures' do
        expect(client).to receive(:delete).with('bulk/tags/subscribers', {taggings: taggings}).and_return(response)

        tags_response = tags.bulk_remove_from_subscribers(taggings)
        expect(tags_response.failures).to be_empty
      end
    end

    # Failures are not well documented in the API documentation
    context 'with failures' do
      let(:response) do
        {
          'failures' => [{
            'subscriber' => {
              'id' => 1,
              'first_name' => 'foo',
              'email_address' => 'foo@bar.com',
              'created_at' => '2023-08-09T04:30:00Z',
            },
            'errors' => ['Test error message']
          }]
        }
      end

      it 'return failures with subscriber and error message' do
        expect(client).to receive(:delete).with('bulk/tags/subscribers', {taggings: taggings}).and_return(response)

        tags_response = tags.bulk_remove_from_subscribers(taggings)
        expect(tags_response.failures.count).to eq(1)
        expect(tags_response.failures.first.subscriber.id).to eq(1)
        expect(tags_response.failures.first.errors.first).to eq('Test error message')
      end
    end
  end
end

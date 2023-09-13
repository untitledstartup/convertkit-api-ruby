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
        response = { 'id' => 1, 'name' => 'tag_name', account_id: 1, state: 'available', 'created_at' => '2023-08-09T04:30:00Z', updated_at: '2023-08-09T04:30:00Z'}
        expect(client).to receive(:post).with('tags', {name: 'tag_name'}).and_return(response)
        tags_response = tags.create('tag_name')
        validate_tag(tags_response, response)
      end
    end
  end

  describe '#add_to_subscriber' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }

    it 'tags a subscriber' do
      response = {
        'id' => 1,
        'state' => 'active',
        'subscribable_id' => 2,
        'subscribable_type' => 'tag',
        'subscriber' => { 'id' => 3 },
        'created_at' => '2023-08-09T04:30:00Z'
      }
      options = {first_name: 'name', fields: { field_key: 'field_value' }, tags:[1,2]}
      expect(client).to receive(:post).with(
        'tags/1/subscribe',
        { email: 'test_email', first_name: 'name', fields: { field_key: 'field_value' }, tags:[1,2]}
      ).and_return(response)

      subscription_response = tags.add_to_subscriber(1, 'test_email', options)
      validate_subscription(subscription_response, response)
    end
  end

  describe '#remove_from_subscriber' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }

    it 'removes a tag from a subscriber' do
      response = { 'id' => 1, 'name' => 'test_tag_name', 'created_at' => '2023-08-09T04:30:00Z' }
      expect(client).to receive(:delete).with('subscribers/3/tags/1').and_return(response)

      tag_response = tags.remove_from_subscriber(1, 3)
      validate_tag(tag_response, response)
    end
  end

  describe '#remove_from_subscriber_by_email' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }

    it 'removes a tag from a subscriber' do
      response = { 'id' => 1, 'name' => 'test_tag_name', 'created_at' => '2023-08-09T04:30:00Z' }
      expect(client).to receive(:post).with('tags/1/unsubscribe', { email: 'test@test.com' }).and_return(response)

      tag_response = tags.remove_from_subscriber_by_email(1, 'test@test.com')
      validate_tag(tag_response, response)
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
end

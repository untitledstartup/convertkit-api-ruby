describe ConvertKit::Resources::Tags do
  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      account = ConvertKit::Resources::Tags.new(client)
      expect(account.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#get_tags' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }
    let(:created_at) { '2023-08-09T04:30:00Z'}
    let(:response) { { 'tags' => [
      {'id' => 1, 'name' => 'test_tag1', 'created_at' => created_at},
      {'id' => 2, 'name' => 'test_tag2', 'created_at' => ''}
    ]}}

    it 'calls the get method on the client' do
      expect(client).to receive(:get).with('tags').and_return(response)
      tags_response = tags.get_tags
      validate_tags(tags_response, response['tags'])
    end
  end

  describe '#create_tag' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }

    context 'when name is a string' do
      it 'creates a tag' do
        response = { 'id' => 1, 'name' => 'tag_name', account_id: 1, state: 'available', 'created_at' => '2023-08-09T04:30:00Z', updated_at: '2023-08-09T04:30:00Z'}
        expect(client).to receive(:post).with('tags', {tag: {name: 'tag_name'}}).and_return(response)
        tags_response = tags.create_tag('tag_name')
        validate_tag(tags_response, response)
      end
    end

    context 'when name is an array' do
      it 'creates tags' do
        response = [
          { 'id' => 1, 'name' => 'tag_name1', account_id: 1, state: 'available', 'created_at' => '2023-08-09T04:30:00Z', updated_at: '2023-08-09T04:30:00Z'},
          { 'id' => 2, 'name' => 'tag_name2', account_id: 1, state: 'available', 'created_at' => '2023-08-10T04:30:00Z', updated_at: '2023-08-10T04:30:00Z'}
        ]
        expect(client).to receive(:post).with('tags', {tag: [{name: 'tag_name1'}, {name: 'tag_name2'}]}).and_return(response)
        tags_response = tags.create_tag(%w[tag_name1 tag_name2])
        validate_tags(tags_response, response)
      end
    end
  end

  describe '#tag_subscriber' do
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

      subscription_response = tags.tag_subscriber(1, 'test_email', options)
      validate_subscription(subscription_response, response)
    end
  end

  describe '#remove_tag_from_subscriber' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }

    it 'removes a tag from a subscriber' do
      response = { 'id' => 1, 'name' => 'test_tag_name', 'created_at' => '2023-08-09T04:30:00Z' }
      expect(client).to receive(:delete).with('subscribers/3/tags/1').and_return(response)

      tag_response = tags.remove_tag_from_subscriber(1, 3)
      validate_tag(tag_response, response)
    end
  end

  describe '#remove_tag_from_subscriber_by_email' do
    let(:tags) { ConvertKit::Resources::Tags.new(client) }

    it 'removes a tag from a subscriber' do
      response = { 'id' => 1, 'name' => 'test_tag_name', 'created_at' => '2023-08-09T04:30:00Z' }
      expect(client).to receive(:post).with('tags/1/unsubscribe', { email: 'test@test.com' }).and_return(response)

      tag_response = tags.remove_tag_from_subscriber_by_email(1, 'test@test.com')
      validate_tag(tag_response, response)
    end
  end

  describe ConvertKit::Resources::TagResponse do
    describe '#initialize' do
      let(:response3) { { 'id' => 2, 'name' => 'test_tag_name', 'created_at' => '2023-08-09T04:30:00Z', updated_at: '2023-08-19T04:30:00Z'} }

      it 'sets the id, name and created_at' do
        response = { 'id' => 1, 'name' => 'test_tag_name', 'created_at' => '2023-08-09T04:30:00Z'}
        tag_response = ConvertKit::Resources::TagResponse.new(response)
        validate_tag(tag_response, response)
      end

      it 'sets the id and name' do
        response = { 'id' => 2, 'name' => 'test_tag_name'}
        tag_response = ConvertKit::Resources::TagResponse.new(response)
        validate_tag(tag_response, response)
      end

      it 'sets the id, name, account_id, state, created_at, updated_at and deleted_at' do
        response = { 'id' => 3, 'name' => 'test_tag_name', 'account_id' => 1, 'state' => 'available', 'created_at' => '2023-08-09T04:30:00Z', updated_at: '2023-08-19T04:30:00Z'}
        tag_response = ConvertKit::Resources::TagResponse.new(response)
        validate_tag(tag_response, response)
      end
    end
  end

  describe ConvertKit::Resources::SubscriptionResponse do
    describe '#initialize' do
      it 'sets the id and state' do
        response = { 'id' => 1, 'state' => 'active'}
        tag_response = ConvertKit::Resources::SubscriptionResponse.new(response)
        validate_subscription(tag_response, response)
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
        tag_response = ConvertKit::Resources::SubscriptionResponse.new(response)
        validate_subscription(tag_response, response)
      end
    end
  end

  def validate_tag(tag, values)
    expect(tag.id).to eq(values['id'])
    expect(tag.name).to eq(values['name'])
    expect(tag.account_id).to eq(values['account_id'])
    expect(tag.state).to eq(values['state'])

    expect(tag.created_at).to eq(DateTime.parse(values['created_at'])) unless values.fetch('created_at', '').strip.empty?
    expect(tag.updated_at).to eq(DateTime.parse(values['updated_at'])) unless values.fetch('updated_at', '').strip.empty?
    expect(tag.deleted_at).to eq(DateTime.parse(values['deleted_at'])) unless values.fetch('deleted_at', '').strip.empty?
  end

  def validate_tags(tags, values)
    tags.each_with_index do |tag, index|
      validate_tag(tag, values[index])
    end
  end

  def validate_subscription(subscription, value)
    expect(subscription.id).to eq(value['id'])
    expect(subscription.state).to eq(value['state'])
    expect(subscription.source).to eq(value['source'])
    expect(subscription.referrer).to eq(value['referrer'])
    expect(subscription.subscribable_id).to eq(value['subscribable_id'])
    expect(subscription.subscribable_type).to eq(value['subscribable_type'])
    expect(subscription.subscriber_id).to eq(value.dig('subscriber', 'id'))
    expect(subscription.created_at).to eq(DateTime.parse(value['created_at'])) unless value.fetch('created_at', '').strip.empty?
  end
end

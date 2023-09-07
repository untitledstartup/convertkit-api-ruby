describe ConvertKit::Resources::Sequences do
  include Validators::SequenceValidators
  include Validators::SubscriptionValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      sequences = ConvertKit::Resources::Sequences.new(client)
      expect(sequences.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#list' do
    let(:sequences) { ConvertKit::Resources::Sequences.new(client) }

    it 'returns a list of sequences' do
      response = { 'courses' => [
        {'id' => 1, 'name' => 'test_sequence1', 'created_at' => '2023-09-05T00:00:00Z'},
        {'id' => 2, 'name' => 'test_sequence2', 'created_at' => ''}
      ]}

      expect(client).to receive(:get).with('sequences').and_return(response)
      sequences_response = sequences.list
      validate_sequences(sequences_response, response['courses'])
    end
  end

  describe '#add_subscriber' do
    let(:sequences) { ConvertKit::Resources::Sequences.new(client) }

    it 'adds a subscriber to a sequence' do
      response = {
        'id' => 1,
        'state' => 'active',
        'subscribable_id' => 2,
        'subscribable_type' => 'course',
        'subscriber' => { 'id' => 3 },
        'created_at' => '2023-09-05T00:00:00Z'
      }
      options = {first_name: 'name', fields: { field_key: 'field_value' }, tags: [1,2]}
      expect(client).to receive(:post).with(
        'sequences/1/subscribe',
        { email: 'test_email', first_name: 'name', fields: { field_key: 'field_value' }, tags:[1,2]}
      ).and_return(response)

      subscription_response = sequences.add_subscriber(1, 'test_email', options)
      validate_subscription(subscription_response, response)
    end
  end

  describe '#subscriptions' do
    let(:sequences) { ConvertKit::Resources::Sequences.new(client) }

    it 'returns a list of subscriptions' do
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
            'subscribable_type' => 'Course',
            'created_at' => '2023-09-05T00:00:00Z',
            'subscriber' => { 'id' => 1}
          },
          {
            'id' => 3,
            'state' => 'active',
            'source' => 'source',
            'referrer' => 'referrer',
            'subscribable_id' => 1,
            'subscribable_type' => 'Course',
            'created_at' => '2023-09-05T00:00:00Z',
            'subscriber' => { 'id' => 2}
          }
        ]
      }
      expect(client).to receive(:get).with('sequences/1/subscriptions', {}).and_return(response)
      subscriptions_response = sequences.subscriptions(1)
      validate_subscriptions(subscriptions_response, response)
    end
  end
end

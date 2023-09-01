describe ConvertKit::Resources::Subscribers do
  include Validators::SubscriberValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      account = ConvertKit::Resources::Subscribers.new(client)
      expect(account.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#get_subscribers' do
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
      subscribers_response = subscribers.get_subscribers
      validate_subscribers(subscribers_response, response)
    end
  end
end

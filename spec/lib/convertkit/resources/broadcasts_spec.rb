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
end

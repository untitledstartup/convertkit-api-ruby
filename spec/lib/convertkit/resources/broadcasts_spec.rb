describe ConvertKit::Resources::Broadcasts do
  include Validators::BroadcastValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      broadcasts = ConvertKit::Resources::Broadcasts.new(client)
      expect(broadcasts.instance_variable_get(:@client)).to be(client)
    end
  end
end

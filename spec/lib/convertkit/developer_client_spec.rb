describe ConvertKit::DeveloperClient do
  let(:connection) { double('connection') }

  describe '#initialize' do
    it 'sets the api_key' do
      expect(ConvertKit::Connection).to receive(:new)
                                          .with(ConvertKit::Client::API_URL, api_key: 'test_token')
                                          .and_return(connection)
      client = ConvertKit::DeveloperClient.new('test_token')
      expect(client.instance_variable_get(:@connection)).to eq(connection)
    end
  end
end
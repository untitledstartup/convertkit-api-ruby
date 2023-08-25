describe ConvertKit::Client do
  let(:connection) { double('connection') }

  describe '#initialize' do
    it 'sets the auth_token' do
      expect(ConvertKit::ConnectionHelper).to receive(:get_connection)
        .with(ConvertKit::Client::API_URL, auth_token: 'test_token')
        .and_return(connection)
      client = ConvertKit::Client.new('test_token')
      expect(client.instance_variable_get(:@connection)).to eq(connection)
    end
  end

  describe '#account' do
    let(:client) { ConvertKit::Client.new('test_token') }

    before do
      allow(ConvertKit::ConnectionHelper).to receive(:get_connection).and_return(connection)
    end

    it 'returns an account resource' do
      expect(client.account).to be_a(ConvertKit::Resources::Account)
      expect(client.account.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#get' do
    let(:client) { ConvertKit::Client.new('test_token') }
    let(:response) { double('response', success?: true, body: 'test_body') }

    it 'calls the get method on the connection' do
      expect(client.instance_variable_get(:@connection)).to receive(:get).with('test_path', {}).and_return(response)
      expect(client.get('test_path')).to eq('test_body')
    end
  end

  describe '#post' do
    let(:client) { ConvertKit::Client.new('test_token') }
    let(:response) { double('response', success?: true, body: 'test_body') }

    it 'calls the get method on the connection' do
      expect(client.instance_variable_get(:@connection)).to receive(:post).with('test_path', {}).and_return(response)
      expect(client.post('test_path')).to eq('test_body')
    end
  end

  describe '#handle_response' do
    let(:client) { ConvertKit::Client.new('test_token') }

    context 'when the response is successful' do
      let(:response) { double('response', success?: true, body: 'test_body') }

      it 'returns the response body' do
        expect(client.send(:handle_response, response)).to eq('test_body')
      end
    end

    context 'when the response is not successful' do
      let(:response) { double('response', success?: false, body: 'test_body') }

      it 'raises an APIError' do
        expect { client.send(:handle_response, response) }.to raise_error(ConvertKit::APIError)
      end
    end
  end
end

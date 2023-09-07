describe ConvertKit::Client do
  let(:connection) { double('connection') }

  describe '#initialize' do
    it 'sets the auth_token' do
      expect(ConvertKit::Connection).to receive(:new)
        .with(ConvertKit::Client::API_URL, auth_token: 'test_token')
        .and_return(connection)
      client = ConvertKit::Client.new('test_token')
      expect(client.instance_variable_get(:@connection)).to eq(connection)
    end
  end

  describe '#account' do
    let(:client) { ConvertKit::Client.new('test_token') }

    before do
      allow(ConvertKit::Connection).to receive(:new).and_return(connection)
    end

    it 'returns an account resource' do
      expect(client.account).to be_a(ConvertKit::Resources::Account)
      expect(client.account.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#tags' do
    let(:client) { ConvertKit::Client.new('test_token') }

    before do
      allow(ConvertKit::Connection).to receive(:new).and_return(connection)
    end

    it 'returns a tags resource' do
      expect(client.tags).to be_a(ConvertKit::Resources::Tags)
      expect(client.tags.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#subscribers' do
    let(:client) { ConvertKit::Client.new('test_token') }

    before do
      allow(ConvertKit::Connection).to receive(:new).and_return(connection)
    end

    it 'returns a subscribers resource' do
      expect(client.subscribers).to be_a(ConvertKit::Resources::Subscribers)
      expect(client.subscribers.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#sequences' do
    let(:client) { ConvertKit::Client.new('test_token') }

    before do
      allow(ConvertKit::Connection).to receive(:new).and_return(connection)
    end

    it 'returns a sequences resource' do
      expect(client.sequences).to be_a(ConvertKit::Resources::Sequences)
      expect(client.sequences.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#custom_fields' do
    let(:client) { ConvertKit::Client.new('test_token') }

    before do
      allow(ConvertKit::Connection).to receive(:new).and_return(connection)
    end

    it 'returns a custom fields resource' do
      expect(client.custom_fields).to be_a(ConvertKit::Resources::CustomFields)
      expect(client.custom_fields.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#webhooks' do
    let(:client) { ConvertKit::Client.new('test_token') }

    before do
      allow(ConvertKit::Connection).to receive(:new).and_return(connection)
    end

    it 'returns a webhooks resource' do
      expect(client.webhooks).to be_a(ConvertKit::Resources::Webhooks)
      expect(client.webhooks.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#purchass' do
    let(:client) { ConvertKit::Client.new('test_token') }

    before do
      allow(ConvertKit::Connection).to receive(:new).and_return(connection)
    end

    it 'returns a purchases resource' do
      expect(client.purchases).to be_a(ConvertKit::Resources::Purchases)
      expect(client.purchases.instance_variable_get(:@client)).to be(client)
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

  describe '#delete' do
    let(:client) { ConvertKit::Client.new('test_token') }
    let(:response) { double('response', success?: true, body: 'test_body') }

    it 'calls the get method on the connection' do
      expect(client.instance_variable_get(:@connection)).to receive(:delete).with('test_path', {}).and_return(response)
      expect(client.delete('test_path')).to eq('test_body')
    end
  end

  describe '#put' do
    let(:client) { ConvertKit::Client.new('test_token') }
    let(:response) { double('response', success?: true, body: 'test_body') }

    it 'calls the get method on the connection' do
      expect(client.instance_variable_get(:@connection)).to receive(:put).with('test_path', {}).and_return(response)
      expect(client.put('test_path')).to eq('test_body')
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
      let(:response) { double('response', success?: false, body: 'Bad Request', status: 400) }

      it 'raises an APIError' do
        expect { client.send(:handle_response, response) }.to raise_error(ConvertKit::APIError, '400: Bad Request')
      end
    end
  end
end

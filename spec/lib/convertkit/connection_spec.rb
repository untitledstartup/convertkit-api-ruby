describe ConvertKit::Connection do
  let!(:url) { 'https://api.convertkit.com/alpha' }

  describe '#initialize' do
    it 'creates a new Faraday connection' do
      expect(Faraday).to receive(:new).with(url: url, headers: {'content-type' => 'application/json' })
      ConvertKit::Connection.new(url)
    end
  end

  describe '#get' do
    let!(:connection) { double('connection') }
    let!(:env) { double('Env', body: '{"message":"response_hash"}') }
    let!(:response) { double('response', env: env ) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(response).to receive(:body).and_return(response.env.body)
    end

    it 'calls the get method on the connection' do
      expect(connection).to receive(:get).with('test_path', '{"hash":"request_hash"}').and_return(response)
      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).get('test_path', {hash: 'request_hash'})
    end
  end

  describe '#post' do
    let!(:connection) { double('connection') }
    let!(:env) { double('Env', body: '{"message":"response_hash"}') }
    let!(:response) { double('response', env: env ) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(response).to receive(:body).and_return(response.env.body)
    end

    it 'calls the get method on the connection' do
      expect(connection).to receive(:post).with('test_path', '{"hash":"request_hash"}').and_return(response)
      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).post('test_path', {hash: 'request_hash'})
    end
  end

  describe '#delete' do
    let!(:connection) { double('connection') }
    let!(:env) { double('Env', body: '{"message":"response_hash"}') }
    let!(:response) { double('response', env: env ) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(response).to receive(:body).and_return(response.env.body)
    end

    it 'calls the get method on the connection' do
      expect(connection).to receive(:delete).with('test_path', '{"hash":"request_hash"}').and_return(response)
      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).delete('test_path', {hash: 'request_hash'})
    end
  end
end

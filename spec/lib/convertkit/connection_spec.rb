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
    let!(:response) { double('response', env: env, status: 200 ) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(response).to receive(:body).and_return(response.env.body)
    end

    it 'calls the get method on the connection' do
      expect(connection).to receive(:get).with('test_path', {hash: 'request_hash'}).and_return(response)
      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).get('test_path', {hash: 'request_hash'})
    end
  end

  describe '#post' do
    let!(:connection) { double('connection') }
    let!(:env) { double('Env', body: '{"message":"response_hash"}') }
    let!(:response) { double('response', env: env, status: 200 ) }

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
    let!(:builder) { double('builder') }
    let!(:env) { double('Env', body: '{"message":"response_hash"}') }
    let!(:response) { double('response', env: env, status: 200 ) }

    before do
      allow(Faraday::RackBuilder).to receive(:new).and_return(builder)
      allow(response).to receive(:body).and_return(response.env.body)
    end

    it 'calls the get method on the connection' do
      expect_any_instance_of(Faraday::Connection).to receive(:delete).with('test_path').and_call_original
      expect(builder).to receive(:build_response) do |connection, request|
        expect(request.path).to eq('test_path')
        expect(request.method).to eq(:delete)
        expect(request.body).to eq('{"hash":"request_hash"}')
      end.and_return(response)

      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).delete('test_path', {hash: 'request_hash'})
    end
  end

  describe '#put' do
    let!(:connection) { double('connection') }
    let!(:env) { double('Env', body: '{"message":"response_hash"}') }
    let!(:response) { double('response', env: env, status: 200 ) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(response).to receive(:body).and_return(response.env.body)
    end

    it 'calls the get method on the connection' do
      expect(connection).to receive(:put).with('test_path', '{"hash":"request_hash"}').and_return(response)
      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).put('test_path', {hash: 'request_hash'})
    end
  end

  describe 'when the response is not successful' do
    let!(:connection) { double('connection') }

    before do
      allow(Faraday).to receive(:new).and_return(connection)

    end

    it 'raises an ResourceNotFoundError' do
      message = '{"errors": "Data not found"}'
      response = double('response', env: double('Env', body: message), body: message , status: 404 )
      allow(response.env).to receive(:body=)
      allow(connection).to receive(:post).and_return(response)

      expect { ConvertKit::Connection.new(url).post('test_path', {hash: 'request_hash'}) }.to raise_error(ConvertKit::ResourceNotFoundError, message)
    end

    it 'raises an BadDataError' do
      message = '{"errors": "Missing required parameter"}'
      response = double('response', env: double('Env', body: message), body: message, status: 422)
      allow(response.env).to receive(:body=)
      allow(connection).to receive(:post).and_return(response)

      expect { ConvertKit::Connection.new(url).post('test_path', {hash: 'request_hash'}) }.to raise_error(ConvertKit::BadDataError, message)
    end

    it 'raises an RateLimitError' do
      message = ''
      response = double('response', env: double('Env', body: message), body: message, status: 429)
      allow(response.env).to receive(:body=)
      allow(connection).to receive(:post).and_return(response)

      expect { ConvertKit::Connection.new(url).post('test_path', {hash: 'request_hash'}) }.to raise_error(ConvertKit::RateLimitError, message)
    end

    it 'raises an ServerError' do
      message = '{"errors": "Internal Server Error"}'
      response = double('response', env: double('Env', body: message), body: message, status: 500)
      allow(response.env).to receive(:body=)
      allow(connection).to receive(:post).and_return(response)

      expect { ConvertKit::Connection.new(url).post('test_path', {hash: 'request_hash'}) }.to raise_error(ConvertKit::ServerError, message)
    end

    it 'raises an BadGatewayError' do
      message = ''
      response = double('response', env: double('Env', body: message), body: message, status: 502)
      allow(response.env).to receive(:body=)
      allow(connection).to receive(:post).and_return(response)

      expect { ConvertKit::Connection.new(url).post('test_path', {hash: 'request_hash'}) }.to raise_error(ConvertKit::BadGatewayError, message)
    end

    it 'raises an ServiceUnavailableError' do
      message = ''
      response = double('response', env: double('Env', body: message), body: message, status: 503)
      allow(response.env).to receive(:body=)
      allow(connection).to receive(:post).and_return(response)

      expect { ConvertKit::Connection.new(url).post('test_path', {hash: 'request_hash'}) }.to raise_error(ConvertKit::ServiceUnavailableError, message)
    end

    it 'raises an GatewayTimeoutError' do
      message = ''
      response = double('response', env: double('Env', body: message), body: message, status: 504)
      allow(response.env).to receive(:body=)
      allow(connection).to receive(:post).and_return(response)

      expect { ConvertKit::Connection.new(url).post('test_path', {hash: 'request_hash'}) }.to raise_error(ConvertKit::GatewayTimeoutError, message)
    end
  end
end

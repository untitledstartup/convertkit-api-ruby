describe ConvertKit::Connection do
  let!(:url) { 'https://api.convertkit.com/alpha' }

  describe '#initialize' do
    it 'creates a new Faraday connection' do
      expect(Faraday).to receive(:new).with(url: url, headers: {'Content-Type' => 'application/json' })
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

    it 'sends an empty body when no params are given' do
      expect(connection).to receive(:post).with('test_path', '').and_return(response)
      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).post('test_path')
    end
  end

  describe '#post_form' do
    let!(:faraday_conn) { double('faraday_connection') }
    let!(:request_headers) { {} }
    let!(:request) { double('request', headers: request_headers) }
    let!(:env) { double('Env', body: '') }
    let!(:response) { double('response', env: env, status: 200) }

    before do
      allow(Faraday).to receive(:new).and_return(faraday_conn)
      allow(response).to receive(:body).and_return(response.env.body)
    end

    it 'posts a form-encoded body with the right Content-Type' do
      received_body = nil
      expect(faraday_conn).to receive(:post).with('oauth/revoke') do |&block|
        allow(request).to receive(:body=) { |b| received_body = b }
        block.call(request)
        response
      end

      ConvertKit::Connection.new(url).post_form('oauth/revoke', { token: 'abc', client_id: 'foo' })

      expect(request_headers['Content-Type']).to eq('application/x-www-form-urlencoded')
      expect(received_body).to eq('token=abc&client_id=foo')
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

    it 'sends an empty body when no params are given' do
      expect_any_instance_of(Faraday::Connection).to receive(:delete).with('test_path').and_call_original
      expect(builder).to receive(:build_response) do |connection, request|
        expect(request.body).to eq('')
      end.and_return(response)

      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).delete('test_path')
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

    it 'sends an empty body when no params are given' do
      expect(connection).to receive(:put).with('test_path', '').and_return(response)
      allow(env).to receive(:body=).with({"message" => "response_hash"})

      ConvertKit::Connection.new(url).put('test_path')
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
      response = double('response', env: double('Env', body: message), body: message, status: 429, headers: {})
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

  describe 'checking the HTTP status of a Faraday response' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:connection) { ConvertKit::Connection.new(url) }

    before do
      allow(Faraday).to receive(:new).and_wrap_original do |original, *args, &block|
        original.call(*args) do |builder|
          block&.call(builder)
          builder.adapter(:test, stubs)
        end
      end
    end

    it 'raises a RateLimitError carrying the status, the body and the Retry-After delay for a text 429' do
      stubs.get('/alpha/subscribers') { [429, { 'Content-Type' => 'text/plain', 'Retry-After' => '30' }, 'Retry later.'] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::RateLimitError) { |error|
        expect(error.message).to eq('HTTP 429 non-JSON body: Retry later.')
        expect(error.status).to eq(429)
        expect(error.retry_after).to eq(30)
      }
    end

    it 'converts an HTTP-date Retry-After into seconds from now' do
      now = Time.utc(2026, 10, 21, 18, 0, 0)
      allow(Time).to receive(:now).and_return(now)
      stubs.get('/alpha/subscribers') { [429, { 'Retry-After' => (now + 90).httpdate }, 'Retry later.'] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::RateLimitError) { |error|
        expect(error.retry_after).to eq(90)
      }
    end

    it 'treats an HTTP-date Retry-After already in the past as no delay' do
      now = Time.utc(2026, 10, 21, 18, 0, 0)
      allow(Time).to receive(:now).and_return(now)
      stubs.get('/alpha/subscribers') { [429, { 'Retry-After' => (now - 90).httpdate }, 'Retry later.'] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::RateLimitError) { |error|
        expect(error.retry_after).to eq(0)
      }
    end

    it 'leaves the retry delay nil when Kit sends no Retry-After' do
      stubs.get('/alpha/subscribers') { [429, {}, 'Retry later.'] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::RateLimitError) { |error|
        expect(error.retry_after).to be_nil
      }
    end

    it 'leaves the retry delay nil when Retry-After is neither seconds nor an HTTP-date' do
      stubs.get('/alpha/subscribers') { [429, { 'Retry-After' => 'soon' }, 'Retry later.'] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::RateLimitError) { |error|
        expect(error.retry_after).to be_nil
      }
    end

    it 'keeps the parsed body as the message of a JSON 429' do
      body = { 'errors' => ['Too many requests'] }
      stubs.get('/alpha/subscribers') { [429, { 'Retry-After' => '5' }, JSON.generate(body)] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::RateLimitError) { |error|
        expect(error.message).to eq(body.to_s)
        expect(error.retry_after).to eq(5)
      }
    end

    it 'puts only the first 200 bytes of a non-JSON body in the message' do
      html = "<html>#{'x' * 500}</html>"
      stubs.get('/alpha/subscribers') { [503, { 'Content-Type' => 'text/html' }, html] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::ServiceUnavailableError) { |error|
        expect(error.message).to eq("HTTP 503 non-JSON body: #{html.byteslice(0, 200)}")
        expect(error.status).to eq(503)
      }
    end

    it 'keeps the message valid UTF-8 when the 200-byte cut splits a character' do
      body = "#{'a' * 199}é and more"
      stubs.get('/alpha/subscribers') { [500, {}, body] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::ServerError) { |error|
        expect(error.message).to be_valid_encoding
        expect(error.message).to start_with("HTTP 500 non-JSON body: #{'a' * 199}")
      }
    end

    it 'raises a ServerError for a 5xx status without its own error class' do
      stubs.get('/alpha/subscribers') { [520, {}, 'Web server is returning an unknown error'] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::ServerError) { |error|
        expect(error.message).to eq('HTTP 520 non-JSON body: Web server is returning an unknown error')
        expect(error.status).to eq(520)
      }
    end

    it 'raises a ServerError with the parsed body for a JSON 501' do
      body = { 'errors' => ['Not Implemented'] }
      stubs.get('/alpha/subscribers') { [501, {}, JSON.generate(body)] }

      expect { connection.get('subscribers') }.to raise_error(ConvertKit::ServerError, body.to_s)
    end

    it 'raises the typed 4xx error for a non-JSON 404' do
      stubs.get('/alpha/subscribers/1') { [404, {}, 'Not Found'] }

      expect { connection.get('subscribers/1') }.to raise_error(ConvertKit::ResourceNotFoundError) { |error|
        expect(error.message).to eq('HTTP 404 non-JSON body: Not Found')
        expect(error.status).to eq(404)
      }
    end

    it 'raises the typed 4xx error with the parsed body for a JSON 422' do
      body = { 'errors' => ['Email address is invalid'] }
      stubs.post('/alpha/subscribers') { [422, {}, JSON.generate(body)] }

      expect { connection.post('subscribers', { email_address: 'x' }) }.to raise_error(ConvertKit::BadDataError) { |error|
        expect(error.message).to eq(body.to_s)
        expect(error.status).to eq(422)
      }
    end

    it 'returns a JSON 401 with its parsed body for the caller to handle' do
      body = { 'errors' => ['The access token was revoked'] }
      stubs.get('/alpha/account') { [401, {}, JSON.generate(body)] }

      response = connection.get('account')

      expect(response.status).to eq(401)
      expect(response.body).to eq(body)
    end

    it 'raises an InvalidResponseError for a non-JSON body on a status the caller handles' do
      stubs.get('/alpha/account') { [401, {}, '<html>Unauthorized</html>'] }

      expect { connection.get('account') }.to raise_error(ConvertKit::InvalidResponseError) { |error|
        expect(error.message).to eq('HTTP 401 non-JSON body: <html>Unauthorized</html>')
        expect(error.status).to eq(401)
      }
    end

    it 'raises an InvalidResponseError for a non-JSON 200' do
      stubs.get('/alpha/account') { [200, {}, 'OK'] }

      expect { connection.get('account') }.to raise_error(ConvertKit::InvalidResponseError, 'HTTP 200 non-JSON body: OK')
    end

    it 'returns a JSON 200 with its parsed body' do
      stubs.get('/alpha/account') { [200, {}, '{"name":"Kit"}'] }

      expect(connection.get('account').body).to eq('name' => 'Kit')
    end

    it 'returns an empty 204 unchanged' do
      stubs.delete('/alpha/tags/1') { [204, {}, ''] }

      response = connection.delete('tags/1')

      expect(response.status).to eq(204)
      expect(response.body).to eq('')
    end
  end
end

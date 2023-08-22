describe ConvertKit::OAuth do
  let!(:client_id) { 'client_id' }
  let!(:client_secret) { 'client_secret' }
  let!(:redirect_uri) { 'redirect_uri' }
  let!(:code) { 'code' }
  let!(:refresh_token) { 'refresh_token' }
  let!(:url) { 'https://app.convertkit.com/' }
  let!(:token_path) { 'oauth/token' }
  let!(:connection) { double('connection') }
  let!(:response) { double('response') }

  describe '#initialize' do
    it 'sets client id, client secret and connection' do
      expect(ConvertKit::ConnectionHelper).to receive(:get_connection).with(url).and_return(connection)

      oauth = ConvertKit::OAuth.new(client_id, client_secret)
      expect(oauth.instance_variable_get(:@id)).to eq(client_id)
      expect(oauth.instance_variable_get(:@secret)).to eq(client_secret)
      expect(oauth.instance_variable_get(:@redirect_uri)).to eq(nil)
      expect(oauth.instance_variable_get(:@code)).to eq(nil)
      expect(oauth.instance_variable_get(:@refresh_token)).to eq(nil)
      expect(oauth.instance_variable_get(:@conn)).to eq(connection)
    end

    it 'sets client id, client secret, redirect uri, code, refresh token and connection' do
      expect(ConvertKit::ConnectionHelper).to receive(:get_connection).with(url).and_return(connection)

      oauth = ConvertKit::OAuth.new(client_id, client_secret, redirect_uri: redirect_uri, code: code, refresh_token: refresh_token)
      expect(oauth.instance_variable_get(:@id)).to eq(client_id)
      expect(oauth.instance_variable_get(:@secret)).to eq(client_secret)
      expect(oauth.instance_variable_get(:@redirect_uri)).to eq(redirect_uri)
      expect(oauth.instance_variable_get(:@code)).to eq(code)
      expect(oauth.instance_variable_get(:@refresh_token)).to eq(refresh_token)
      expect(oauth.instance_variable_get(:@conn)).to eq(connection)
    end
  end

  describe '#get_token' do
    let(:oauth) { ConvertKit::OAuth.new(client_id, client_secret, redirect_uri: redirect_uri, code: code, refresh_token: refresh_token) }

    before do
      allow(ConvertKit::ConnectionHelper).to receive(:get_connection).with(url).and_return(connection)
    end

    context 'when server returns success response' do
      let!(:access_token_response) { { 'access_token' => 'token', 'expires_in'=> 3600, 'created_at'=> Time.now.to_i } }

      before do
        allow(response).to receive(:success?).and_return(true)
        allow(response).to receive(:body).and_return(access_token_response)
      end

      it 'returns access token response' do
        expect(connection).to receive(:post).with(token_path, {
          client_id: client_id,
          client_secret: client_secret,
          code: code,
          grant_type: 'authorization_code',
          redirect_uri: redirect_uri
        }).and_return(response)

        response = oauth.get_token

        expect(response.access_token).to eq(access_token_response['access_token'])
        expect(response.expires_in).to eq(access_token_response['expires_in'])
        expect(response.created_at).to eq(access_token_response['created_at'])
      end

      context 'with code and redirect uri provided' do
        let!(:new_code) { 'new_code' }
        let(:new_redirect_uri) { 'new_redirect_uri' }

        it 'returns access token response' do
          expect(connection).to receive(:post).with(token_path, {
            client_id: client_id,
            client_secret: client_secret,
            code: new_code,
            grant_type: 'authorization_code',
            redirect_uri: new_redirect_uri
          }).and_return(response)

          response = oauth.get_token(code: new_code, redirect_uri: new_redirect_uri)

          expect(response.access_token).to eq(access_token_response['access_token'])
          expect(response.expires_in).to eq(access_token_response['expires_in'])
          expect(response.created_at).to eq(access_token_response['created_at'])
        end
      end
    end

    context 'when server returns error response' do
      before do
        allow(connection).to receive(:post).and_return(response)
        allow(response).to receive(:success?).and_return(false)
      end

      it 'raises invalid grant error' do
        error_response = { 'error' => 'invalid_request', 'error_description' => 'The request is missing a required parameter' }
        allow(response).to receive(:body).and_return(error_response)
        expect { oauth.get_token }.to raise_error(ConvertKit::InvalidRequestError, error_response['error_description'])
      end

      it 'raises unauthorized client error' do
        error_response = { 'error' => 'unauthorized_client', 'error_description' => 'The client is not authorized to request an authorization code using this method.' }
        allow(response).to receive(:body).and_return(error_response)
        expect { oauth.get_token }.to raise_error(ConvertKit::UnauthorizedClientError, error_response['error_description'])
      end

      it 'raises access denied error' do
        error_response = { 'error' => 'access_denied', 'error_description' => 'The resource owner or authorization server denied the request.' }
        allow(response).to receive(:body).and_return(error_response)
        expect { oauth.get_token }.to raise_error(ConvertKit::AccessDeniedError, error_response['error_description'])
      end

      it 'raises unsupported response type error' do
        error_response = { 'error' => 'unsupported_response_type', 'error_description' => 'The authorization server does not support obtaining an authorization code using this method.' }
        allow(response).to receive(:body).and_return(error_response)
        expect { oauth.get_token }.to raise_error(ConvertKit::UnsupportedResponseTypeError, error_response['error_description'])
      end

      it 'raises invalid scope error' do
        error_response = { 'error' => 'invalid_scope', 'error_description' => 'The requested scope is invalid, unknown, or malformed.' }
        allow(response).to receive(:body).and_return(error_response)
        expect { oauth.get_token }.to raise_error(ConvertKit::InvalidScopeError, error_response['error_description'])
      end

      it 'raises generic error' do
        error_response = { 'error' => 'server_error', 'error_description' => 'The authorization server encountered an unexpected condition that prevented it from fulfilling the request.' }
        allow(response).to receive(:body).and_return(error_response)
        expect { oauth.get_token }.to raise_error(ConvertKit::OauthError, error_response['error_description'])
      end
    end
  end
end

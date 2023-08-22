describe ConvertKit::AccessTokenResponse do
  let(:now) { Time.now.to_i }
  let(:response) { { 'access_token' => 'test_access_token', 'token_type' => 'test_token_type', 'expires_in' => '3600', 'refresh_token' => 'test_refresh_token', 'scope' => 'test_scope', 'created_at' => now.to_s } }

  describe '#initialize' do
    it 'sets the access_token, token_type, expires_in, expires_at, refresh_token, scope, and created_at' do
      access_token_response = ConvertKit::AccessTokenResponse.new(response)
      expect(access_token_response.access_token).to eq('test_access_token')
      expect(access_token_response.token_type).to eq('test_token_type')
      expect(access_token_response.expires_in).to eq(3600)
      expect(access_token_response.refresh_token).to eq('test_refresh_token')
      expect(access_token_response.scope).to eq('test_scope')
      expect(access_token_response.created_at).to eq(now)
      expect(access_token_response.instance_variable_get(:@expires_at)).to eq(now + 3600)
    end

    context 'when missing the expires_in' do
      before { response.delete('expires_in') }

      it 'does not set expires_in and expires_at' do
        access_token_response = ConvertKit::AccessTokenResponse.new(response)
        expect(access_token_response.access_token).to eq('test_access_token')
        expect(access_token_response.token_type).to eq('test_token_type')
        expect(access_token_response.expires_in).to be_nil
        expect(access_token_response.refresh_token).to eq('test_refresh_token')
        expect(access_token_response.scope).to eq('test_scope')
        expect(access_token_response.created_at).to eq(now)
        expect(access_token_response.instance_variable_get(:@expires_at)).to be_nil
      end
    end

    context 'when missing the created_at' do
      before { response.delete('created_at') }

      it 'does not set created_at and expires_at' do
        access_token_response = ConvertKit::AccessTokenResponse.new(response)
        expect(access_token_response.access_token).to eq('test_access_token')
        expect(access_token_response.token_type).to eq('test_token_type')
        expect(access_token_response.expires_in).to eq(3600)
        expect(access_token_response.refresh_token).to eq('test_refresh_token')
        expect(access_token_response.scope).to eq('test_scope')
        expect(access_token_response.created_at).to be_nil
        expect(access_token_response.instance_variable_get(:@expires_at)).to be_nil
      end
    end
  end

  describe '#expires?' do
    context 'when expires_at is set' do
      it 'returns true' do
        access_token_response = ConvertKit::AccessTokenResponse.new(response)
        expect(access_token_response.expires?).to eq(true)
      end
    end

    context 'when expires_at is not set' do
      before { response.delete('expires_in') }

      it 'returns false' do
        access_token_response = ConvertKit::AccessTokenResponse.new(response)
        expect(access_token_response.expires?).to eq(false)
      end
    end
  end

  describe '#expired?' do
    context 'when expires_at is set' do
      context 'when expires_at is in the past' do
        before { response['created_at'] = (now - 4000).to_s }

        it 'returns true' do
          access_token_response = ConvertKit::AccessTokenResponse.new(response)
          expect(access_token_response.expired?).to eq(true)
        end
      end

      context 'when expires_at is in the future' do
        it 'returns false' do
          access_token_response = ConvertKit::AccessTokenResponse.new(response)
          expect(access_token_response.expired?).to eq(false)
        end
      end
    end

    context 'when expires_at is not set' do
      before { response.delete('expires_in') }

      it 'returns false' do
        access_token_response = ConvertKit::AccessTokenResponse.new(response)
        expect(access_token_response.expired?).to eq(false)
      end
    end
  end
end

module ConvertKit
  class OAuth
    URL = 'https://app.convertkit.com/'.freeze
    TOKEN_PATH = 'oauth/token'.freeze

    def initialize(client_id, client_secret, options)
      @id = client_id
      @secret = client_secret
      @redirect_uri = options[:redirect_uri]
      @code = options[:code]
      @refresh_token = options[:refresh_token]
      @conn = ConvertKit::Connection.new(URL)
    end

    def get_token(option = {})
      params = {
        client_id: @id,
        client_secret: @secret,
        code: option[:code] || @code,
        grant_type: 'authorization_code',
        redirect_uri: @redirect_uri
      }

      @conn.post(TOKEN_PATH, params)
    end

    def refresh_token(option = {})
      params = {
        client_id: @id,
        client_secret: @secret,
        refresh_token: option[:refresh_token] || @refresh_token,
        grant_type: 'refresh_token'
      }

      @conn.post(TOKEN_PATH, params)
    end
  end
end

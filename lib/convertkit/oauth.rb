module ConvertKit
  # Use this class to get an access token or refresh token using the OAuth2 flow. The client id and client secret
  # should be obtained from ConvertKit and is required for this flow. The code should be obtained when initially connect
  # to ConvertKit via the https://app.convertkit.com/oauth/authorize endpoint.
  class OAuth
    URL = 'https://app.convertkit.com/'.freeze
    TOKEN_PATH = 'oauth/token'.freeze

    def initialize(client_id, client_secret, options = {})
      @id = client_id
      @secret = client_secret
      @redirect_uri = options[:redirect_uri]
      @code = options[:code]
      @refresh_token = options[:refresh_token]
      @connection = ConvertKit::ConnectionHelper.get_connection(URL)
    end

    def get_token(options = {})
      params = {
        client_id: @id,
        client_secret: @secret,
        code: options[:code] || @code,
        grant_type: 'authorization_code',
        redirect_uri: options[:redirect_uri] || @redirect_uri
      }

      handle_response @connection.post(TOKEN_PATH, params)
    end

    def refresh_token(option = {})
      params = {
        client_id: @id,
        client_secret: @secret,
        refresh_token: option[:refresh_token] || @refresh_token,
        grant_type: 'refresh_token'
      }

      handle_response @connection.post(TOKEN_PATH, params)
    end

    private

    def handle_response(response)
      if response.success?
        AccessTokenResponse.new response.body
      else
        error_description = response.body['error_description']
        case response.body['error']
        when 'invalid_request'
          raise ConvertKit::InvalidRequestError, error_description
        when 'unauthorized_client'
          raise ConvertKit::UnauthorizedClientError, error_description
        when 'access_denied'
          raise ConvertKit::AccessDeniedError, error_description
        when 'unsupported_response_type'
          raise ConvertKit::UnsupportedResponseTypeError, error_description
        when 'invalid_scope'
          raise ConvertKit::InvalidScopeError, error_description
        else
          raise ConvertKit::OauthError, error_description
        end
      end
    end
  end
end

require 'net/http'

module ConvertKit
  # Use this class to get an access token or refresh token using the OAuth2 flow. The client id and client secret
  # should be obtained from ConvertKit and is required for this flow. The code should be obtained when initially connect
  # to ConvertKit via the https://app.convertkit.com/oauth/authorize endpoint.
  class OAuth
    URL = 'https://app.convertkit.com/'.freeze
    TOKEN_PATH = 'oauth/token'.freeze
    # RFC 7009 token revocation endpoint. Lives under api.kit.com/v4 (not the legacy app.convertkit.com host)
    # and requires application/x-www-form-urlencoded — see https://developers.kit.com/api-reference/oauth-token-revocation
    REVOKE_URL = 'https://api.kit.com/v4/oauth/revoke'.freeze

    def initialize(client_id, client_secret, options = {})
      @id = client_id
      @secret = client_secret
      @redirect_uri = options[:redirect_uri]
      @code = options[:code]
      @refresh_token = options[:refresh_token]
      @connection = ConvertKit::Connection.new(URL)
    end

    def get_token(options = {})
      params = {
        client_id: @id,
        client_secret: @secret,
        code: options[:code] || @code,
        grant_type: 'authorization_code',
        redirect_uri: options[:redirect_uri] || @redirect_uri
      }

      response = handle_response(@connection.post(TOKEN_PATH, params))
      AccessTokenResponse.new(response)
    end

    def refresh_token(option = {})
      params = {
        client_id: @id,
        client_secret: @secret,
        refresh_token: option[:refresh_token] || @refresh_token,
        grant_type: 'refresh_token'
      }

      response = handle_response(@connection.post(TOKEN_PATH, params))
      AccessTokenResponse.new(response)
    end

    # POSTs a form-encoded RFC 7009 revoke request directly via Net::HTTP. The gem's Connection
    # class sends application/json, which Kit's /oauth/revoke cannot parse; per RFC 7009 the endpoint
    # returns 200 even for unparseable requests, so any Content-Type other than form-encoded would
    # silently no-op without actually revoking the token.
    def revoke_token(token)
      response = Net::HTTP.post_form(
        URI(REVOKE_URL),
        token: token,
        client_id: @id,
        client_secret: @secret,
        token_type_hint: 'access_token'
      )

      unless response.code.to_i.between?(200, 299)
        raise ConvertKit::OauthError, "Kit /oauth/revoke returned HTTP #{response.code}: #{response.body}"
      end

      true
    end

    private

    def handle_response(response, raw_response = false)
      if response.success?
        raw_response ? response: response.body
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

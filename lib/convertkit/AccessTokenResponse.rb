module ConvertKit
  class AccessTokenResponse
    attr_accessor :access_token, :token_type, :expires_in, :refresh_token, :scope, :created_at

    def initialize(response = {})
      @access_token = response['access_token']
      @token_type = response['token_type']
      @expires_in = response['expires_in']&.to_i
      @refresh_token = response['refresh_token']
      @scope = response['scope']
      @created_at = response['created_at']&.to_i
      @expires_at = @created_at + @expires_in if @expires_in && @created_at
    end

    def expires?
      !!@expires_at
    end

    def expired?
      expires? && (Time.now.to_i > @expires_at)
    end
  end
end

module ConvertKit
  class InvalidRequestError < StandardError; end
  class UnauthorizedClientError < StandardError; end
  class AccessDeniedError < StandardError; end
  class UnsupportedResponseTypeError < StandardError; end
  class InvalidScopeError < StandardError; end
  class OauthError < StandardError; end
  class APIError < StandardError; end
end

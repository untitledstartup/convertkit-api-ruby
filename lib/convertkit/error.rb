module ConvertKit
  class InvalidRequestError < StandardError; end
  class UnauthorizedClientError < StandardError; end
  class AccessDeniedError < StandardError; end
  class UnsupportedResponseTypeError < StandardError; end
  class InvalidScopeError < StandardError; end
  class OauthError < StandardError; end
  class UnauthorizedError < StandardError; end
  class ResourceNotFoundError < StandardError; end
  class BadDataError < StandardError; end
  class RateLimitError < StandardError; end
  class ServerError < StandardError; end
  class BadGatewayError < StandardError; end
  class ServiceUnavailableError < StandardError; end
  class GatewayTimeoutError < StandardError; end
  class APIError < StandardError; end
end

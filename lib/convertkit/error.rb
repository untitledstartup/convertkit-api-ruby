module ConvertKit
  class InvalidRequestError < StandardError; end
  class UnauthorizedClientError < StandardError; end
  class AccessDeniedError < StandardError; end
  class UnsupportedResponseTypeError < StandardError; end
  class InvalidScopeError < StandardError; end
  class OauthError < StandardError; end
  class UnauthorizedError < StandardError; end

  # Raised by Connection for a response it will not hand back to the caller.
  class ResponseError < StandardError
    attr_reader :status

    def initialize(message = nil, status = nil)
      super(message)
      @status = status
    end
  end

  class ResourceNotFoundError < ResponseError; end
  class BadDataError < ResponseError; end

  class RateLimitError < ResponseError
    # Seconds to wait before retrying, from Retry-After; nil when the response has none.
    attr_reader :retry_after

    def initialize(message = nil, status = nil, retry_after = nil)
      super(message, status)
      @retry_after = retry_after
    end
  end

  class ServerError < ResponseError; end
  class BadGatewayError < ResponseError; end
  class ServiceUnavailableError < ResponseError; end
  class GatewayTimeoutError < ResponseError; end
  # A body that is not JSON on a status Connection would otherwise return to the caller.
  class InvalidResponseError < ResponseError; end
  class APIError < StandardError; end
end

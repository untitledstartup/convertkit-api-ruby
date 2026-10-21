require 'faraday'
require 'json'
require 'time'
require 'uri'

module ConvertKit
  class Connection

    MIME_TYPE = 'application/json'.freeze
    HTTP_METHODS = %i(get post delete put).freeze
    NON_JSON_SNIPPET_BYTES = 200

    def initialize(url, options = {})
      @url = url

      @connection = Faraday.new(url: @url, headers: default_headers(options)) do |builder|
        if options[:auth_token]
          builder.request :authorization, 'Bearer', options[:auth_token]
        end
      end
    end

    # Defined wrapper methods for Faraday's HTTP methods
    HTTP_METHODS.each do |method|
      define_method(method) do |path, params = {}|
        # Allow delete requests to have a body. See https://github.com/lostisland/faraday/issues/693#issuecomment-466086832
        if method == :delete
          response = @connection.public_send(method, path) do |request|
            request.body = process_request(method, params)
          end
        else
          response = @connection.public_send(method, path, process_request(method, params))
        end
        process_response(response)
      end
    end

    # POSTs application/x-www-form-urlencoded params, overriding the connection's default
    # JSON Content-Type for this single request. Required for OAuth 2.0 endpoints whose RFCs
    # (e.g., RFC 7009 token revocation) mandate form-encoded bodies.
    def post_form(path, params)
      response = @connection.post(path) do |request|
        request.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        request.body = URI.encode_www_form(params)
      end
      process_response(response)
    end

    private

    def default_headers(options)
      headers = { 'Content-Type' => MIME_TYPE }
      headers['X-Kit-Api-Key'] = options[:api_key] if options[:api_key]
      headers
    end

    def process_request(method, params)
      return params if method == :get
      return params if params.empty?

      JSON.generate(params)
    end

    def process_response(response)
      status = response.status
      error_class = error_class_for(status)
      raw_body = response.body.to_s
      json = parse_json_body(response, raw_body)

      if error_class
        message = json ? response.body : non_json_message(status, raw_body)
        raise rate_limit_error(message, response) if error_class == ConvertKit::RateLimitError

        raise error_class.new(message, status: status)
      end

      raise ConvertKit::InvalidResponseError.new(non_json_message(status, raw_body), status: status) unless json

      response # Let the caller handle the response
    end

    # Based on the response codes in https://developers.kit.com/api-reference/response-codes
    def error_class_for(status)
      case status
      when 404 then ConvertKit::ResourceNotFoundError
      when 422 then ConvertKit::BadDataError
      when 429 then ConvertKit::RateLimitError
      when 502 then ConvertKit::BadGatewayError
      when 503 then ConvertKit::ServiceUnavailableError
      when 504 then ConvertKit::GatewayTimeoutError
      when 500..599 then ConvertKit::ServerError
      end
    end

    # Throttle and proxy error pages are not always JSON; a parse failure must not hide the status.
    def parse_json_body(response, raw_body)
      return true if raw_body.strip.empty?

      response.env.body = JSON.parse(raw_body)
      true
    rescue JSON::ParserError
      false
    end

    def non_json_message(status, raw_body)
      snippet = raw_body.dup.force_encoding(Encoding::UTF_8).byteslice(0, NON_JSON_SNIPPET_BYTES).scrub
      "HTTP #{status} non-JSON body: #{snippet}"
    end

    def rate_limit_error(message, response)
      ConvertKit::RateLimitError.new(message, status: response.status, retry_after: retry_after_seconds(response.headers['Retry-After']))
    end

    # Kit documents no rate-limit reset header, so Retry-After (RFC 9110 §10.2.3: delay-seconds
    # or an HTTP-date) is the only delay a 429 can carry.
    def retry_after_seconds(value)
      value = value.to_s.strip
      return if value.empty?
      return value.to_i if value.match?(/\A\d+\z/)

      [(Time.httpdate(value) - Time.now).ceil, 0].max
    rescue ArgumentError
      nil
    end
  end
end

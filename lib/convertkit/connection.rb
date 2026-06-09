require 'faraday'
require 'json'

module ConvertKit
  class Connection

    MIME_TYPE = 'application/json'.freeze
    HTTP_METHODS = %i(get post delete put).freeze

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
      # Need to parse the response body for successful and error responses
      response.env.body = JSON.parse(response.env.body) unless response.body.strip.empty?

      # Based on error responses mentioned in https://developers.convertkit.com/v4_alpha.html#api-basics
      case response.status
      when 404
        raise ConvertKit::ResourceNotFoundError, response.body
      when 422
        raise ConvertKit::BadDataError, response.body
      when 429
        raise ConvertKit::RateLimitError, response.body
      when 500
        raise ConvertKit::ServerError, response.body
      when 502
        raise ConvertKit::BadGatewayError, response.body
      when 503
        raise ConvertKit::ServiceUnavailableError, response.body
      when 504
        raise ConvertKit::GatewayTimeoutError, response.body
      else
        response # Let the caller handle the response
      end
    end
  end
end

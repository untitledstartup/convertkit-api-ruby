require 'faraday'
require 'json'

module ConvertKit
  class Connection

    MIME_TYPE = 'application/json'.freeze
    HTTP_METHODS = %i(get post delete put).freeze

    def initialize(url, options = {})
      @url = url

      @connection = Faraday.new(url: @url, headers: {'content-type' => MIME_TYPE }) do |builder|
        builder.request :authorization, 'Bearer', options[:auth_token] if options[:auth_token]
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

    private

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

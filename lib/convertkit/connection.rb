require 'faraday'
require 'json'

module ConvertKit
  class Connection

    MIME_TYPE = 'application/json'.freeze

    def initialize(url, options = {})
      @url = url

      @connection = Faraday.new(url: @url, headers: {'content-type' => MIME_TYPE }) do |builder|
        builder.request :authorization, 'Bearer', options[:auth_token] if options[:auth_token]
      end
    end

    def get(path, params = {})
      response = @connection.get(path, process_request(params))
      process_response(response)
    end

    def post(path, params = {})
      response = @connection.post(path, process_request(params))
      process_response(response)
    end

    def delete(path, params = {})
      response = @connection.delete(path, process_request(params))
      process_response(response)
    end

    private

    def process_request(params)
      return params if params.empty?

      JSON.generate(params)
    end

    def process_response(response)
      return response if response.body.strip.empty?

      response.env.body = JSON.parse(response.env.body)
      response
    end
  end
end

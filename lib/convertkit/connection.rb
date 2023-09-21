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
        response = @connection.public_send(method, path, process_request(method, params))
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
      return response if response.body.strip.empty?

      response.env.body = JSON.parse(response.env.body)
      response
    end
  end
end

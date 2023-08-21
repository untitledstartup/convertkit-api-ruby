require 'faraday'

module ConvertKit
  class ConnectionHelper
    class << self
      def get_connection(url, options = {})
        @url = url

        @conn = Faraday.new(url: @url) do |builder|
          builder.request :authorization, 'Bearer', options[:auth_token] if options[:auth_token]
          builder.request :json
          builder.response :json
        end
      end
    end
  end
end

module ConvertKit
  module Resources
    class Broadcasts
      PATH = 'broadcasts'.freeze

      def initialize(client)
        @client = client
      end

      # Return a list of broadcasts for the account
      # See https://developers.convertkit.com/#list-broadcasts for details.
      # @param page [Integer] The page number to return. Each page returns up to 50 broadcasts. The default is 1.
      def list(page= nil)
        request_options = { page: page }.compact

        response = @client.get(PATH, request_options)
        response['broadcasts'].map do |broadcast|
          ConvertKit::Resources::BroadcastResponse.new(broadcast)
        end
      end
    end
  end
end

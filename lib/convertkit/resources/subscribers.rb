module ConvertKit
  module Resources
    class Subscribers
      PATH = 'subscribers'.freeze

      def initialize(client)
        @client = client
      end

      # Returns a list of subscribers for the account.
      # See https://developers.convertkit.com/#list-subscribers for details
      # @param [Hash] options
      # @option options [Integer] :page The page of results to return.
      # @option options [Integer] :from Filter subscribers added on or after date
      # @option options [Integer] :to Filter subscribers added on or before date
      # @option options [String] :updated_from Filter subscribers updated after date
      # @option options [String] :updated_to Filter subscribers updated before date
      # @option options [String] :sort_order Sort order for results(`asc` or `desc`)
      # @option options [String] :sort_field Field to sort results by
      # @option options [String] :email_address Search subscribers by email address
      def get_subscribers(options = {})
        request_options = options.slice(:page, :from, :to, :updated_from, :updated_to, :sort_order, :sort_field, :email_address)
        response = @client.get(PATH, request_options)
        SubscribersResponse.new(response)
      end
    end
  end
end

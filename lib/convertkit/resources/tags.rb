module ConvertKit
  module Resources
    class Tags
      PATH = 'tags'.freeze

      def initialize(client)
        @client = client
      end

      # Returns a list of tags for the account.
      # See https://developers.convertkit.com/#list-tags for details
      def list
        response = @client.get(PATH)

        response['tags'].map do |tag|
          TagResponse.new(tag)
        end
      end

      # Creates a new tag for the account.
      # See https://developers.convertkit.com/v4_alpha.html#post__alpha_tags for details
      # @param [String] name
      def create(name)
        response = @client.post(PATH, { name: name })

        TagResponse.new(response)
      end

      # Tags a subscriber with the given email address.
      # See https://developers.convertkit.com/v4_alpha.html#convertkit-api-api-alpha-tags-subscriber for details
      # @param [Integer] tag_id
      # @param [Hash] options
      # @option options [Integer] :id Subscriber Id
      # @option options [String] :email_address  Subscriber's email address
      def add_to_subscriber(tag_id, options = {})
        request = {
          email_address: options[:email_address],
          id: options[:id]
        }.compact

        response = @client.post("#{PATH}/#{tag_id}/subscribers", request, true)

        response.success?
      end

      # Removes a tag from a subscriber.
      # See https://developers.convertkit.com/v4_alpha.html#delete_alpha_tags-tag_id-_subscribers for details.
      # @param [Integer] tag_id
      # @param [Hash] options
      # @option options [Integer] :id Subscriber Id
      # @option options [String] :email_address  Subscriber's email address
      def remove_from_subscriber(tag_id, options = {})
        request = {
          email_address: options[:email_address],
          id: options[:id]
        }.compact
        response = @client.delete("#{PATH}/#{tag_id}/subscribers", request, true)

        response.success?
      end

      # Returns a list of subscriptions for a given tag.
      # See https://developers.convertkit.com/#list-subscriptions-to-a-tag for details.
      # @param [Integer] tag_id
      # @param [Hash] options
      # @option options [String] :sort_order  Possible values are 'asc' or 'desc'
      # @option options [String] :subscriber_state  Possible values are 'active' or 'cancelled'
      # @option options [Integer] :page  Page number to return. Each page returns 50 results. The default value is 1.
      def subscriptions(tag_id, options = {})
        request_options = options.slice(:sort_order, :subscriber_state, :page)
        response = @client.get("#{PATH}/#{tag_id}/subscriptions", request_options)

        SubscriptionsResponse.new(response)
      end
    end
  end
end

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

      # Update the name of a Tag
      # See https://developers.kit.com/v4#update-tag-name for details
      # @param [Integer] tag_id
      # @param [Hash] options
      # @option options [String] :name New name for Tag
      def update(tag_id, options = {})
        request_options = options.slice(:name)
        response = @client.put("#{PATH}/#{tag_id}", request_options)
        TagResponse.new(response['tag'])
      end

      # Tags a subscriber
      # See https://developers.convertkit.com/v4.html#tag-a-subscriber for details
      # @param [Integer] tag_id
      # @param [Integer] subscriber_id
      def add_to_subscriber(tag_id, subscriber_id)
        response = @client.post("#{PATH}/#{tag_id}/subscribers/#{subscriber_id}", '', true)

        response.success?
      end

      # Tag a subscriber by email address
      # See https://developers.convertkit.com/v4.html#tag-a-subscriber-by-email-address for details
      # @param [Integer] tag_id
      # @param [String] email_address
      # @param [Hash] options
      # @option options [Integer] :subscriber_id
      def add_to_subscriber_by_email_address(tag_id, email_address, options = {})
        request = {
          email_address: email_address,
          id: options[:subscriber_id]
        }.compact
        response = @client.post("#{PATH}/#{tag_id}/subscribers", request, true)

        response.success?
      end

      # Removes a tag from a subscriber.
      # See https://developers.convertkit.com/v4.html#remove-tag-from-subscriber for details.
      # @param [Integer] tag_id
      # @param [Integer] subscriber_id
      def remove_from_subscriber(tag_id, subscriber_id)
        response = @client.delete("#{PATH}/#{tag_id}/subscribers/#{subscriber_id}", '', true)

        response.success?
      end

      # Removes a tag from a subscriber by email address.
      # See https://developers.convertkit.com/v4.html#remove-tag-from-subscriber-by-email-address for details
      # @param [Integer] tag_id
      # @param [String] email_address
      def remove_from_subscriber_by_email_address(tag_id, email_address)
        response = @client.delete("#{PATH}/#{tag_id}/subscribers", { email_address: email_address }, true)

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

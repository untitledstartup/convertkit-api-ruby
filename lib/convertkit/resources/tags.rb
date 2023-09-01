module ConvertKit
  module Resources
    class Tags
      PATH = 'tags'.freeze

      def initialize(client)
        @client = client
      end

      # Returns a list of tags for the account.
      # See https://developers.convertkit.com/#list-tags for details
      def get_tags
        response = @client.get(PATH)

        response['tags'].map do |tag|
          TagResponse.new(tag)
        end
      end

      # Creates a new tag for the account.
      # See https://developers.convertkit.com/#create-a-tag for details
      # @param [String, Array<String>] name
      def create_tag(name)
        is_array = name.is_a? Array
        request = is_array ? name.map { |n| { name: n } } : { name: name }

        response = @client.post(PATH, {tag: request})

        if is_array
          response.map do |tag|
            TagResponse.new(tag)
          end
        else
          TagResponse.new(response)
        end
      end

      # Tags a subscriber with the given email address.
      # See https://developers.convertkit.com/#tag-a-subscriber for details
      # @param [Integer] tag_id
      # @param [String] email
      # @param [Hash] options
      # @option options [String] :first_name Subscriber's first name
      # @option options [Hash] :fields  Key value pairs for existing custom fields
      # @option options [Array<Integer>] :tags Array of tag ids to subscribe to
      def tag_subscriber(tag_id, email, options = {})
        request = {
          email: email,
          first_name: options[:first_name],
          fields: options[:fields],
          tags: options[:tags]
        }.compact

        response = @client.post("#{PATH}/#{tag_id}/subscribe", request)

        TagSubscriptionResponse.new(response)
      end

      # Removes a tag from a subscriber.
      # See https://developers.convertkit.com/#remove-tag-from-a-subscriber for details.
      # @param [Integer] tag_id
      # @param [Integer] subscriber_id
      def remove_tag_from_subscriber(tag_id, subscriber_id)
        response = @client.delete("subscribers/#{subscriber_id}/#{PATH}/#{tag_id}")

        TagResponse.new(response)
      end

      # Removes a tag from a subscriber using an email address.
      # See https://developers.convertkit.com/#remove-tag-from-a-subscriber-by-email for details.
      # @param [Integer] tag_id
      # @param [String] subscriber_email
      def remove_tag_from_subscriber_by_email(tag_id, subscriber_email)
        response = @client.post("#{PATH}/#{tag_id}/unsubscribe", { email: subscriber_email})

        TagResponse.new(response)
      end

      # Returns a list of subscriptions for a given tag.
      # See https://developers.convertkit.com/#list-subscriptions-to-a-tag for details.
      # @param [Integer] tag_id
      # @param [Hash] options
      # @option options [String] :sort_order  Can value the values 'asc' or 'desc'
      # @option options [String] :subscriber_state  Can value the values 'active' or 'cancelled'
      # @option options [Integer] :page  Page number to return. Each page returns 50 results.
      def get_tag_subscriptions(tag_id, options = {})
        request_options = options.slice(:sort_order, :subscriber_state, :page)
        response = @client.get("#{PATH}/#{tag_id}/subscriptions", request_options)

        TagSubscriptionsResponse.new(response)
      end
    end
  end
end

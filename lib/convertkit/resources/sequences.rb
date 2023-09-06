module ConvertKit
  module Resources
    class Sequences
      PATH = 'sequences'.freeze

      def initialize(client)
        @client = client
      end

      # Returns a list of sequences for the account.
      # See https://developers.convertkit.com/#list-sequences for details
      def list
        response = @client.get(PATH)

        # TODO: Double check to see if this has now been updated to sequences instead of the old naming convention of courses.
        response['courses'].map do |sequence|
          ConvertKit::Resources::SequenceResponse.new(sequence)
        end
      end

      # Subscribes an email address to a sequence.
      # See https://developers.convertkit.com/#add-subscriber-to-a-sequence for details
      # @param [Integer] id Sequence ID
      # @param [String] email Subscriber's email address
      # @param [Hash] options
      # @option options [String] :first_name Subscriber's first name
      # @option options [Hash] :fields  Key value pairs for existing custom fields
      # @option options [Array<Integer>] :tags Array of tag ids to subscribe to
      def add_subscriber(id, email, options = {})
        request = {
          email: email,
          first_name: options[:first_name],
          fields: options[:fields],
          tags: options[:tags]
        }.compact

        response = @client.post("#{PATH}/#{id}/subscribe", request)

        ConvertKit::Resources::SubscriptionResponse.new(response)
      end

      # Returns a list of subscriptions to a sequence.
      # See https://developers.convertkit.com/#list-subscriptions-to-a-sequence for details
      # @param [Integer] id Sequence ID
      # @param [Hash] options
      # @option options [String] :sort_order Possible values are 'asc' or 'desc'
      # @option options [String] :subscriber_state Possible values are 'active', or 'cancelled'
      # @option options [Integer] :page Page number to return. Each page returns 50 results. The default value is 1.
      def subscriptions(id, options = {})
        request_options = options.slice(:sort_order, :subscriber_state, :page)
        response = @client.get("#{PATH}/#{id}/subscriptions", request_options)

        ConvertKit::Resources::SubscriptionsResponse.new(response)
      end
    end
  end
end

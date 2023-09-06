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
    end
  end
end

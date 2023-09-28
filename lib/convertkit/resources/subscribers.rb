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
      # @option options [Integer] :page The page of results to return. The default value is 1.
      # @option options [Integer] :from Filter subscribers added on or after date
      # @option options [Integer] :to Filter subscribers added on or before date
      # @option options [String] :updated_from Filter subscribers updated after date
      # @option options [String] :updated_to Filter subscribers updated before date
      # @option options [String] :sort_order Sort order for results(`asc` or `desc`)
      # @option options [String] :sort_field Field to sort results by
      # @option options [String] :email_address Search subscribers by email address
      def list(options = {})
        request_options = options.slice(:page, :from, :to, :updated_from, :updated_to, :sort_order, :sort_field, :email_address)
        response = @client.get(PATH, request_options)
        SubscribersResponse.new(response)
      end

      # Returns data for a single subscriber
      # See https://developers.convertkit.com/#view-a-single-subscriber for details
      # @param [Integer] subscriber_id
      def get(subscriber_id)
        response = @client.get("#{PATH}/#{subscriber_id}")
        SubscriberResponse.new(response)
      end

      # Create a new subscriber
      # See https://developers.convertkit.com/v4_alpha.html#post__alpha_subscribers
      # @param [String] email Subscriber's email address
      # @param [Hash] options
      # @option options [String] :first_name Subscriber's first name
      def create(email, options = {})
        request_options = {
          email_address: email,
          first_name: options[:first_name],
        }.compact

        response = @client.post(PATH, request_options)

        SubscriberResponse.new(response['subscriber'])
      end

      # Create multiple subscribers (an upsert operation).
      # @param [Array<Hash>] subscribers
      # @option subscribers [String] :email_address Subscriber's email address
      # @option subscribers [String] :first_name Subscriber's first name
      def bulk_create(subscribers = [])
        raise ArgumentError, 'subscribers must be an array' unless subscribers.is_a?(Array)

        response = @client.post("bulk/#{PATH}", { subscribers: subscribers })

        SubscriberBulkCreateResponse.new(response)
      end

      # Update the information of a subscriber
      # See https://developers.convertkit.com/v4_alpha.html?shell#put_alpha_subscribers-id for details
      # @param [Integer] subscriber_id
      # @param [Hash] options
      # @option options [String] :first_name Subscriber's first name
      # @option options [String] :email_address Subscriber's email address
      # @option options [Hash] :fields  Key value pairs for existing custom fields
      def update(subscriber_id, options = {})
        request_options = options.slice(:first_name, :email_address, :fields)
        response = @client.put("#{PATH}/#{subscriber_id}", request_options)
        SubscriberResponse.new(response['subscriber'])
      end

      # Unsubscribe a subscriber
      # See https://developers.convertkit.com/v4_alpha.html#post_alpha_subscribers-id-_unsubscribe
      # @param [Integer] subscriber_id
      def unsubscribe(subscriber_id)
        response = @client.post("#{PATH}/#{subscriber_id}/unsubscribe", "", raw_response: true)

        response.success?
      end

      # Get a list of tags for a subscriber
      # See https://developers.convertkit.com/#list-tags-for-a-subscriber for details
      # @param [Integer] subscriber_id
      def list_tags(subscriber_id)
        response = @client.get("#{PATH}/#{subscriber_id}/tags")
        response['tags'].map do |tag|
          TagResponse.new(tag)
        end
      end
    end
  end
end

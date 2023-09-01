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

      # Returns data for a single subscriber
      # See https://developers.convertkit.com/#view-a-single-subscriber for details
      # @param [Integer] subscriber_id
      def get_subscriber(subscriber_id)
        response = @client.get("#{PATH}/#{subscriber_id}")
        SubscriberResponse.new(response)
      end

      # Update the information of a subscriber
      # See https://developers.convertkit.com/#update-subscriber for details
      # @param [Integer] subscriber_id
      # @param [Hash] options
      # @option options [String] :first_name Subscriber's first name
      # @option options [String] :email_address Subscriber's email address
      # @option options [Hash] :fields  Key value pairs for existing custom fields
      def update_subscriber(subscriber_id, options = {})
        request_options = options.slice(:first_name, :email_address, :fields)
        response = @client.put("#{PATH}/#{subscriber_id}", request_options)
        SubscriberResponse.new(response)
      end
    end
  end
end

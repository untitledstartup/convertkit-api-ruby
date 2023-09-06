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

      # Create a draft or a scheduled broadcast. A scheduled broadcast requires at least a subject and content.
      # See https://developers.convertkit.com/#create-a-broadcast for details.
      # @param options [Hash] The options to create a broadcast with.
      # @option options [String] :content The broadcast's email content in text or simple HTML.
      # @option options [String] :description The internal description of the broadcast.
      # @option options [String] :email_address Sending email address for the broadcast. The accounts default email address is used if not provided.
      # @option options [String] :email_layout_template The email layout template to use for the broadcast. Defaults to the account email layout template.
      # @option options [Boolean] :public Whether the broadcast is public or not.
      # @option options [String] :published_at The date and time the broadcast should be published. Only applicable to public broadcasts.
      # @option options [String] :send_at The date and time the broadcast should be sent. Leave blank to create a draft.
      # @option options [String] :subject The subject of the broadcast email.
      # @option options [String] :thumbnail_alt The alt text for the public thumbnail image.
      # @option options [String] :thumbnail_url The URL for the thumbnail image to accompany public broadcast.
      def create(options= {})
        request_options = options.slice(:content, :description, :email_address, :email_layout_template, :public, :published_at, :send_at, :subject, :thumbnail_alt, :thumbnail_url).compact
        response = @client.post(PATH, request_options)

        ConvertKit::Resources::BroadcastResponse.new(response['broadcast'])
      end

      # Retrieve a broadcast by id.
      # See https://developers.convertkit.com/#retrieve-a-specific-broadcast for details.
      # @param id [Integer] The id of the broadcast to retrieve.
      def get(id)
        response = @client.get("#{PATH}/#{id}")
        ConvertKit::Resources::BroadcastResponse.new(response['broadcast'])
      end

      def stats(id)
        response = @client.get("#{PATH}/#{id}/stats")
        ConvertKit::Resources::BroadcastStatsResponse.new(response['broadcast'])
      end

      # Update a broadcast by id. Broadcasts that are being sent or have been sent cannot be updated.
      # See https://developers.convertkit.com/#update-a-broadcast for details.
      # @param id [Integer] The id of the broadcast to update.
      # @param options [Hash] The options to create a broadcast with.
      # @option options [String] :content The broadcast's email content in text or simple HTML.
      # @option options [String] :description The internal description of the broadcast.
      # @option options [String] :email_address Sending email address for the broadcast. The accounts default email address is used if not provided.
      # @option options [String] :email_layout_template The email layout template to use for the broadcast. Defaults to the account email layout template.
      # @option options [Boolean] :public Whether the broadcast is public or not.
      # @option options [String] :published_at The date and time the broadcast should be published. Only applicable to public broadcasts.
      # @option options [String] :send_at The date and time the broadcast should be sent. Leave blank to create a draft.
      # @option options [String] :subject The subject of the broadcast email.
      # @option options [String] :thumbnail_alt The alt text for the public thumbnail image.
      # @option options [String] :thumbnail_url The URL for the thumbnail image to accompany public broadcast.
      def update(id, options= {})
        request_options = options.slice(:content, :description, :email_address, :email_layout_template, :public, :published_at, :send_at, :subject, :thumbnail_alt, :thumbnail_url).compact
        response = @client.put("#{PATH}/#{id}", request_options)

        ConvertKit::Resources::BroadcastResponse.new(response['broadcast'])
      end
    end
  end
end

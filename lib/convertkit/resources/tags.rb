module ConvertKit
  module Resources
    class Tags
      PATH = 'tags'.freeze

      def initialize(client)
        @client = client
      end

      def get_tags
        response = @client.get(PATH)

        response['tags'].map do |tag|
          TagResponse.new(tag)
        end
      end

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

      def tag_subscriber(tag_id, email, options = {})
        request = {
          email: email,
          first_name: options[:first_name],
          fields: options[:fields],
          tags: options[:tags]
        }.compact

        response = @client.post("#{PATH}/#{tag_id}/subscribe", request)

        SubscriptionResponse.new(response)
      end

      def remove_tag_from_subscriber(tag_id, subscriber_id)
        response = @client.delete("subscribers/#{subscriber_id}/#{PATH}/#{tag_id}")

        TagResponse.new(response)
      end

      def remove_tag_from_subscriber_by_email(tag_id, subscriber_email)
        response = @client.post("#{PATH}/#{tag_id}/unsubscribe", { email: subscriber_email})

        TagResponse.new(response)
      end
    end

    class TagResponse
      attr_accessor :id, :name, :account_id, :state, :created_at, :updated_at, :deleted_at

      def initialize(response)
        @id = response['id']
        @name = response['name']
        @account_id = response['account_id']
        @state = response['state']
        @created_at = DateTime.parse(response['created_at']) unless response.fetch('created_at', '').strip.empty?
        @updated_at = DateTime.parse(response['updated_at']) unless response.fetch('updated_at', '').strip.empty?
        @deleted_at = DateTime.parse(response['deleted_at']) unless response.fetch('deleted_at', '').strip.empty?
      end
    end

    class SubscriptionResponse
      attr_accessor :id,
                    :state,
                    :source,
                    :referrer,
                    :subscribable_id,
                    :subscribable_type,
                    :subscriber_id,
                    :created_at

      def initialize(response)
        @id = response['id']
        @state = response['state']
        @source = response['source']
        @referrer = response['referrer']
        @subscribable_id = response['subscribable_id']
        @subscribable_type = response['subscribable_type']
        @subscriber_id = response.dig('subscriber', 'id')
        @created_at = DateTime.parse(response['created_at']) unless response.fetch('created_at', '').strip.empty?
      end
    end
  end
end

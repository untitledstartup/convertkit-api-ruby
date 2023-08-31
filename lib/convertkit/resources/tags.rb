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

        TagSubscriptionResponse.new(response)
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
  end
end

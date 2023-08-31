module ConvertKit
  module Resources
    class TagSubscriptionResponse
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

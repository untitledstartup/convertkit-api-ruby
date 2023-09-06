module ConvertKit
  module Resources
    class SubscriptionResponse
      attr_accessor :id,
                    :state,
                    :source,
                    :referrer,
                    :subscribable_id,
                    :subscribable_type,
                    :subscriber,
                    :created_at

      def initialize(response)
        @id = response['id']
        @state = response['state']
        @source = response['source']
        @referrer = response['referrer']
        @subscribable_id = response['subscribable_id']
        @subscribable_type = response['subscribable_type']
        @created_at = ConvertKit::Utils.to_datetime(response['created_at'])
        @subscriber = ConvertKit::Resources::SubscriberResponse.new(response['subscriber']) if response['subscriber']
      end
    end
  end
end

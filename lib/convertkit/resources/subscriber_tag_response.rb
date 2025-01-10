module ConvertKit
  module Resources
    class SubscriberTagResponse
      attr_accessor :tag_id, :subscriber_id

      def initialize(response)
        @tag_id = response['tag_id']
        @subscriber_id = response['subscriber_id']
      end
    end
  end
end

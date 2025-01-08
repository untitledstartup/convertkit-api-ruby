module ConvertKit
  module Resources
    class SubscriberBulkAddTagResponse
      attr_accessor :subscribers, :failures

      def initialize(response)
        @subscribers = response['subscribers'].map do |subscriber|
          ConvertKit::Resources::TaggedSubscriberResponse.new(subscriber)
        end

        @failures = response['failures'].map do |failure|
          ConvertKit::Resources::SubscriberBulkTagFailureResponse.new(failure)
        end
      end
    end
  end
end

module ConvertKit
  module Resources
    class SubscriberBulkCreateResponse
      attr_accessor :subscribers, :failures

      def initialize(response)
        @subscribers = response['subscribers'].map do |subscriber|
          ConvertKit::Resources::SubscriberResponse.new(subscriber)
        end

        @failures = response['failures'].map do |failure|
          ConvertKit::Resources::SubscriberBulkCreateFailureResponse.new(failure)
        end
      end
    end
  end
end

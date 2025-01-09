module ConvertKit
  module Resources
    class SubscriberBulkRemoveTagResponse
      attr_accessor :failures

      def initialize(response)
        @failures = response['failures'].map do |failure|
          ConvertKit::Resources::SubscriberBulkTagFailureResponse.new(failure)
        end
      end
    end
  end
end

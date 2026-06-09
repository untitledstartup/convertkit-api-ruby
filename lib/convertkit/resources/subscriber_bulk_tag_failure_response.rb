module ConvertKit
  module Resources
    class SubscriberBulkTagFailureResponse
      attr_accessor :tagging, :errors

      def initialize(response)
        @tagging = SubscriberTagResponse.new(response['tagging']) if response['tagging']
        @errors = response['errors']
      end
    end
  end
end

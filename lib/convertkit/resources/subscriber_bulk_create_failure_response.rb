module ConvertKit
  module Resources
    class SubscriberBulkCreateFailureResponse
      attr_accessor :body, :errors

      def initialize(response)
        @body = response['body']
        @errors = response['errors']
      end
    end
  end
end

module ConvertKit
  module Resources
    class SubscriberBulkCreateFailureResponse
      attr_accessor :subscriber, :errors

      def initialize(response)
        @subscriber = SubscriberResponse.new(response['subscriber']) if response['subscriber']
        @errors = response['errors']
      end
    end
  end
end

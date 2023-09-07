module ConvertKit
  module Resources
    class SubscriptionsResponse
      attr_accessor :subscriptions, :total_subscriptions, :page, :total_pages

      def initialize(response)
        @total_subscriptions = response['total_subscriptions']
        @page = response['page']
        @total_pages = response['total_pages']
        @subscriptions = response['subscriptions'].map do |subscription|
          ConvertKit::Resources::SubscriptionResponse.new(subscription)
        end
      end
    end
  end
end

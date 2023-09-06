module ConvertKit
  module Resources
    class SubscribersResponse
      attr_accessor :subscribers, :total_subscribers, :page, :total_pages

      def initialize(response)
        @total_subscribers = response['total_subscribers']
        @page = response['page']
        @total_pages = response['total_pages']
        @subscribers = response['subscribers'].map do |subscriber|
          ConvertKit::Resources::SubscriberResponse.new(subscriber)
        end
      end
    end
  end
end

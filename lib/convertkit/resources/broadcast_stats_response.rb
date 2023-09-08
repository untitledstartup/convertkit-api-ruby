module ConvertKit
  module Resources
    class BroadcastStatsResponse
      attr_accessor :broadcast_id,
                    :recipients,
                    :open_rate,
                    :unsubscribes,
                    :total_clicks,
                    :show_total_clicks,
                    :status,
                    :progress

      def initialize(response)
        @broadcast_id = response['id']

        stats = response['stats']
        @recipients = stats['recipients']
        @open_rate = stats['open_rate']
        @unsubscribes = stats['unsubscribes']
        @total_clicks = stats['total_clicks']
        @show_total_clicks = stats['show_total_clicks']
        @status = stats['status']
        @progress = stats['progress']
      end
    end
  end
end

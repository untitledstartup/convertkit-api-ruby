describe ConvertKit::Resources::BroadcastStatsResponse do
  include Validators::BroadcastValidators

  describe '#initialize' do
    it 'sets all the attributes of a broadcast status response' do
      response = {
          'id' => 1,
          'stats' => {
            'recipients' => 10,
            'open_rate' => 80.1,
            'click_rate' => 40.23,
            'unsubscribes' => 'This is the content of the newsletter',
            'total_clicks' => 4,
            'show_total_clicks' => false,
            'status' => 'completed',
            'progress' => 100.0
          }}
      broadcast_stats_response = ConvertKit::Resources::BroadcastStatsResponse.new(response)
      validate_broadcast_stats(broadcast_stats_response, response)
    end
  end
end

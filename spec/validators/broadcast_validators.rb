module Validators
  module BroadcastValidators
    def validate_broadcast(broadcast, values)
      expect(broadcast.id).to eq(values['id'])
      expect(broadcast.subject).to eq(values['subject'])
      expect(broadcast.description).to eq(values['description'])
      expect(broadcast.content).to eq(values['content'])
      expect(broadcast.public).to eq(values['public'])
      expect(broadcast.email).to eq(values['email_address'])
      expect(broadcast.email_layout_template).to eq(values['email_layout_template'])
      expect(broadcast.thumbnail_url).to eq(values['thumbnail_url'])
      expect(broadcast.thumbnail_alt).to eq(values['thumbnail_alt'])
      expect(broadcast.created_at).to eq(DateTime.parse(values['created_at'])) unless values.fetch('created_at', '').strip.empty?
      expect(broadcast.published_at).to eq(DateTime.parse(values['published_at'])) unless values.fetch('published_at', '').strip.empty?
      expect(broadcast.send_at).to eq(DateTime.parse(values['send_at'])) unless values.fetch('send_at', '').strip.empty?
    end

    def validate_broadcast_stats(broadcast_stats, values)
      expect(broadcast_stats.broadcast_id).to eq(values['id'])
      expect(broadcast_stats.recipients).to eq(values['stats']['recipients'])
      expect(broadcast_stats.open_rate).to eq(values['stats']['open_rate'])
      expect(broadcast_stats.unsubscribes).to eq(values['stats']['unsubscribes'])
      expect(broadcast_stats.total_clicks).to eq(values['stats']['total_clicks'])
      expect(broadcast_stats.show_total_clicks).to eq(values['stats']['show_total_clicks'])
      expect(broadcast_stats.status).to eq(values['stats']['status'])
      expect(broadcast_stats.progress).to eq(values['stats']['progress'])
    end
  end
end

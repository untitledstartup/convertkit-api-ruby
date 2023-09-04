describe ConvertKit::Resources::EventResponse do
  include Validators::WebhookValidators

  describe '#initialize' do
    it 'sets the name' do
      response = { 'name' => 'subscriber_activate'}
      event_response = ConvertKit::Resources::EventResponse.new(response)
      validate_event(event_response, response)
    end

    it 'sets the name,  and sequence_id' do
      response = { 'name' => 'subscriber_activate', 'sequence_id' => 1 }
      event_response = ConvertKit::Resources::EventResponse.new(response)
      validate_event(event_response, response)
    end
  end
end

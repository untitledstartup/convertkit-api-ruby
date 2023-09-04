describe ConvertKit::Resources::Webhooks do
  include Validators::WebhookValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      account = ConvertKit::Resources::Webhooks.new(client)
      expect(account.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#create_webhook' do
    let(:webhooks) { ConvertKit::Resources::Webhooks.new(client) }

    it 'creates a webhook' do
      response = {
        'id' => 1,
        'target_url' => 'https://test.com',
        'event' => { 'name' => 'subscriber_activate' }
      }
      expect(client).to receive(:post).with('automations/hooks', { target_url: 'https://test.com', event: {'name' => 'subscriber_activate'}}).and_return(response)
      webhook_response = webhooks.create_webhook('https://test.com', {'name' => 'subscriber_activate'})
      validate_webhook_rule(webhook_response, response)
    end
  end

  describe '#delete_webhook' do
    let(:webhooks) { ConvertKit::Resources::Webhooks.new(client) }

    it 'deletes a webhook successfully' do
      response = { 'success' => true }
      expect(client).to receive(:delete).with('automations/hooks/1').and_return(response)
      expect(webhooks.delete_webhook(1)).to eq(true)
    end

    it 'fails to delete a webhook' do
      response = { 'success' => false }
      expect(client).to receive(:delete).with('automations/hooks/1').and_return(response)
      expect(webhooks.delete_webhook(1)).to eq(false)
    end
  end
end

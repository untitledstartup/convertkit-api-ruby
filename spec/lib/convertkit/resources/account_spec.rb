describe ConvertKit::Resources::Account do
  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      account = ConvertKit::Resources::Account.new(client)
      expect(account.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#get_account' do
    let(:account) { ConvertKit::Resources::Account.new(client) }
    let(:response) { { 'account' => {'name' => 'test_name', 'primary_email_address' => 'test_email'} }}

    it 'calls the get method on the client' do
      expect(client).to receive(:get).with('account').and_return(response)
      account_response = account.get_account
      expect(account_response.name).to eq('test_name')
      expect(account_response.email).to eq('test_email')
    end
  end

  describe ConvertKit::Resources::AccountResponse do
    describe '#initialize' do
      let(:response) { { 'account' => {'name' => 'test_name', 'primary_email_address' => 'test_email'} }}

      it 'sets the name and email' do
        account_response = ConvertKit::Resources::AccountResponse.new(response)
        expect(account_response.name).to eq('test_name')
        expect(account_response.email).to eq('test_email')
      end
    end
  end
end

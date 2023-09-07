describe ConvertKit::Resources::Forms do
  include Validators::FormValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      forms = ConvertKit::Resources::Forms.new(client)
      expect(forms.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#list' do
    let(:forms) { ConvertKit::Resources::Forms.new(client) }

    it 'calls the get method on the client' do
      response = { 'forms' => [
        {'id' => 1, 'uid' => '123', 'name' => 'test_form1', 'archived' => false, 'created_at' => '2023-09-05T00:00:00Z'},
        {'id' => 2, 'uid' => '456', 'name' => 'test_form2', 'archived' => false, 'created_at' => '2023-09-06T00:00:00Z'}
      ]}
      expect(client).to receive(:get).with('forms').and_return(response)
      forms_response = forms.list
      validate_forms(forms_response, response['forms'])
    end
  end
end

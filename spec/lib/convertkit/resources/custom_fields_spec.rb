describe ConvertKit::Resources::CustomFields do
  include Validators::CustomFieldValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      custom_fields = ConvertKit::Resources::CustomFields.new(client)
      expect(custom_fields.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#list' do
    let(:custom_fields) { ConvertKit::Resources::CustomFields.new(client) }

    it 'returns a list of custom fields' do
      response = { 'custom_fields' => [
        {'id' => 1, 'name' => 'ck_field_name1', 'key' => 'test_key1', 'label' => 'test_label_value1' },
        {'id' => 2, 'name' => 'ck_field_name2', 'key' => 'test_key2', 'label' => 'test_label_value2' },
      ]}

      expect(client).to receive(:get).with('custom_fields').and_return(response)
      custom_fields_response = custom_fields.list
      validate_custom_fields(custom_fields_response, response['custom_fields'])
    end
  end
end

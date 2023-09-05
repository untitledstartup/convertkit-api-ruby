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

  describe '#create' do
    let(:custom_fields) { ConvertKit::Resources::CustomFields.new(client) }

    it 'creates a custom field' do
      response = { 'id' => 1, 'name' => 'ck_field1_last_name', 'key' => 'last_name', 'label' => 'Last Name' }

      expect(client).to receive(:post).with('custom_fields', label: 'Last Name').and_return(response)
      custom_field_response = custom_fields.create('Last Name')
      validate_custom_field(custom_field_response, response)
    end

    it 'creates a list of custom fields' do
      response = [
        { 'id' => 1, 'name' => 'ck_field1_first_name', 'key' => 'first_name', 'label' => 'First Name' },
        { 'id' => 2, 'name' => 'ck_field2_last_name', 'key' => 'last_name', 'label' => 'Last Name' }
      ]

      expect(client).to receive(:post).with('custom_fields', label: ['First Name', 'Last Name']).and_return(response)
      custom_fields_response = custom_fields.create(['First Name', 'Last Name'])
      validate_custom_fields(custom_fields_response, response)
    end
  end
end

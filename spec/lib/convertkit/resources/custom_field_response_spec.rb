describe ConvertKit::Resources::CustomFieldResponse do
  include Validators::CustomFieldValidators

  describe '#initialize' do
    it 'sets the id and name' do
      response = { 'id' => 1, 'name' => 'ck_test_field_name'}
      tag_response = ConvertKit::Resources::CustomFieldResponse.new(response)
      validate_custom_field(tag_response, response)
    end

    it 'sets the id, name, key, label' do
      response = { 'id' => 1, 'name' => 'ck_test_field_name', 'key' => 'key_name', 'label' => 'label_value'}
      tag_response = ConvertKit::Resources::CustomFieldResponse.new(response)
      validate_custom_field(tag_response, response)
    end
  end
end

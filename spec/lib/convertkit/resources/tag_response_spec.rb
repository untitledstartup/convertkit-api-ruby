describe ConvertKit::Resources::TagResponse do
  include Validators::TagsValidators

  describe '#initialize' do
    let(:response3) { { 'id' => 2, 'name' => 'test_tag_name', 'created_at' => '2023-08-09T04:30:00Z', updated_at: '2023-08-19T04:30:00Z'} }

    it 'sets the id, name and created_at' do
      response = { 'id' => 1, 'name' => 'test_tag_name', 'created_at' => '2023-08-09T04:30:00Z'}
      tag_response = ConvertKit::Resources::TagResponse.new(response)
      validate_tag(tag_response, response)
    end

    it 'sets the id and name' do
      response = { 'id' => 2, 'name' => 'test_tag_name'}
      tag_response = ConvertKit::Resources::TagResponse.new(response)
      validate_tag(tag_response, response)
    end

    it 'sets the id, name, account_id, state, created_at, updated_at and deleted_at' do
      response = { 'id' => 3, 'name' => 'test_tag_name', 'account_id' => 1, 'state' => 'available', 'created_at' => '2023-08-09T04:30:00Z', updated_at: '2023-08-19T04:30:00Z'}
      tag_response = ConvertKit::Resources::TagResponse.new(response)
      validate_tag(tag_response, response)
    end
  end
end

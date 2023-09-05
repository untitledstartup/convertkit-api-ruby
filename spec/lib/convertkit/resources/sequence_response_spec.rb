describe ConvertKit::Resources::SequenceResponse do
  include Validators::SequenceValidators

  describe '#initialize' do
    it 'sets the id and name' do
      response = {
        'id' => 123,
        'name' => 'Test Sequence',
        'created_at' => '2023-09-05T00:00:00Z',
      }
      sequence = ConvertKit::Resources::SequenceResponse.new(response)
      validate_sequence(sequence, response)
    end

    it 'sets the id, name and created_at' do
      response = {
        'id' => 123,
        'name' => 'Test Sequence',
        'created_at' => '2023-09-05T00:00:00Z',
      }
      sequence = ConvertKit::Resources::SequenceResponse.new(response)
      validate_sequence(sequence, response)
    end
  end
end

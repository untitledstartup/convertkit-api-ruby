describe ConvertKit::Resources::Sequences do
  include Validators::SequenceValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      sequences = ConvertKit::Resources::Sequences.new(client)
      expect(sequences.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#list' do
    let(:sequences) { ConvertKit::Resources::Sequences.new(client) }

    it 'returns a list of sequences' do
      response = { 'courses' => [
        {'id' => 1, 'name' => 'test_sequence1', 'created_at' => '2023-09-05T00:00:00Z'},
        {'id' => 2, 'name' => 'test_sequence2', 'created_at' => ''}
      ]}

      expect(client).to receive(:get).with('sequences').and_return(response)
      sequences_response = sequences.list
      validate_sequences(sequences_response, response['courses'])
    end
  end
end

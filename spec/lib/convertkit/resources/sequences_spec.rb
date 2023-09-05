describe ConvertKit::Resources::Sequences do
  include Validators::SequenceValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      sequences = ConvertKit::Resources::Sequences.new(client)
      expect(sequences.instance_variable_get(:@client)).to be(client)
    end
  end
end

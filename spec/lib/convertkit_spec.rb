describe ConvertKit do
  describe '#version' do
    it 'returns the version number' do
      expect(ConvertKit.version).to eq(ConvertKit::VERSION)
    end
  end
end

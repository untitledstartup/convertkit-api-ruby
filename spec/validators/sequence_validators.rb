module Validators
  module SequenceValidators
    def validate_sequence(sequence, values)
      expect(sequence.id).to eq(values['id'])
      expect(sequence.name).to eq(values['name'])
      expect(sequence.created_at).to eq(DateTime.parse(values['created_at'])) unless values.fetch('created_at', '').strip.empty?
    end
  end
end

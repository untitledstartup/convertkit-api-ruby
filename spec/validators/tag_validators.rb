module Validators
  module TagValidators

    def validate_tag(tag, values)
      expect(tag.id).to eq(values['id'])
      expect(tag.name).to eq(values['name'])
      expect(tag.account_id).to eq(values['account_id'])
      expect(tag.state).to eq(values['state'])

      expect(tag.created_at).to eq(DateTime.parse(values['created_at'])) unless values.fetch('created_at', '').strip.empty?
      expect(tag.updated_at).to eq(DateTime.parse(values['updated_at'])) unless values.fetch('updated_at', '').strip.empty?
      expect(tag.deleted_at).to eq(DateTime.parse(values['deleted_at'])) unless values.fetch('deleted_at', '').strip.empty?
    end

    def validate_tags(tags, values)
      tags.each_with_index do |tag, index|
        validate_tag(tag, values[index])
      end
    end
  end
end

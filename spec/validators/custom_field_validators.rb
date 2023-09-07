module Validators
  module CustomFieldValidators

    def validate_custom_field(custom_field, values)
      expect(custom_field.id).to eq(values['id'])
      expect(custom_field.name).to eq(values['name'])
      expect(custom_field.key).to eq(values['key'])
      expect(custom_field.label).to eq(values['label'])
    end

    def validate_custom_fields(custom_fields, values)
      custom_fields.each_with_index do |custom_field, index|
        validate_custom_field(custom_field, values[index])
      end
    end
  end
end

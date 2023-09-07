module Validators
  module FormValidators

    def validate_form(form, values)
      expect(form.id).to eq(values['id'])
      expect(form.uid).to eq(values['uid'])
      expect(form.name).to eq(values['name'])
      expect(form.type).to eq(values['type'])
      expect(form.embed_js).to eq(values['embed_js'])
      expect(form.embed_url).to eq(values['embed_url'])
      expect(form.archived).to eq(values['archived'])
      expect(form.created_at).to eq(DateTime.parse(values['created_at'])) unless values.fetch('created_at', '').strip.empty?
    end

    def validate_forms(forms, values)
      forms.each_with_index do |form, index|
        validate_form(form, values[index])
      end
    end
  end
end

describe ConvertKit::Resources::FormResponse do
  include Validators::FormValidators

  describe '#initialize' do
    it 'sets the id and name' do
      response = { 'id' => 1, 'name' => 'test form'}
      form_response = ConvertKit::Resources::FormResponse.new(response)
      validate_form(form_response, response)
    end

    it 'sets all the form attributes' do
      response = {
        'id' => 1,
        'uid' => '123',
        'name' => 'test form',
        'type' => 'embed',
        'embed_js' => 'http://example.com/embed.js',
        'embed_url' => 'http://example.com',
        'archived' => false,
        'created_at' => '2023-09-05T00:00:00Z'
      }
      form_response = ConvertKit::Resources::FormResponse.new(response)
      validate_form(form_response, response)
    end
  end
end

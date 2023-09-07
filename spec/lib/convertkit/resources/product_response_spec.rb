describe ConvertKit::Resources::ProductResponse do
  include Validators::PurchaseValidators

  describe '#initialize' do
    it 'returns a product response object' do
      response = {
        'pid' => 1,
        'uid' => '123',
        'lid' => '11-12-23',
        'sku' => 'sku_123',
        'name' => 'Test Product Name',
        'unit_price' => 10,
        'quantity' => 1
      }
      product_response = ConvertKit::Resources::ProductResponse.new(response)
      validate_product(product_response, response)
    end
  end
end

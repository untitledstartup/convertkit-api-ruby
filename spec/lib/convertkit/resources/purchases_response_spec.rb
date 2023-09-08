describe ConvertKit::Resources::PurchasesResponse do
  include Validators::PurchaseValidators

  describe '#initialize' do
    it 'returns a purchases response object' do
      products = [
          {
          'pid' => 1,
          'uid' => '123',
          'lid' => '11-12-23',
          'sku' => 'sku_123',
          'name' => 'Test Product Name',
          'unit_price' => 10,
          'quantity' => 1
        },
        {
          'pid' => 2,
          'uid' => '456',
          'lid' => '33-34-45',
          'sku' => 'sku_456',
          'name' => 'Test Product Name2',
          'unit_price' => 20,
          'quantity' => 2
        }
      ]

      purchases = [{
        'id' => 1,
        'transaction_id' => '123',
        'status' => 'complete',
        'email_address' => 'test@test.com',
        'currency' => 'USD',
        'subtotal' => 10,
        'discount' => 0,
        'tax' => 0,
        'total' => 10,
        'transaction_time' => '2023-09-05T00:00:00Z',
        'products' => products
      }]

      response = {
        'total_purchases' => 1,
        'page' => 1,
        'total_pages' => 1,
        'purchases' => purchases
      }

      purchases_response = ConvertKit::Resources::PurchasesResponse.new(response)
      validate_purchases(purchases_response, response)
    end
  end
end

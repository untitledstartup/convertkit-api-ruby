describe ConvertKit::Resources::Purchases do
  include Validators::PurchaseValidators

  let(:client) { double('client') }

  describe '#initialize' do
    it 'sets the client' do
      purchases = ConvertKit::Resources::Purchases.new(client)
      expect(purchases.instance_variable_get(:@client)).to be(client)
    end
  end

  describe '#list' do
    let(:purchases) { ConvertKit::Resources::Purchases.new(client) }

    it 'calls the get method on the client' do
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

      purchases_array = [{
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
        'purchases' => purchases_array
      }

      expect(client).to receive(:get).with('purchases').and_return(response)
      purchases_response = purchases.list
      validate_purchases(purchases_response, response)
    end
  end
end

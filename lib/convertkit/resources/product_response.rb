module ConvertKit
  module Resources
    class ProductResponse
      attr_accessor :pid, :lid, :sku, :name, :unit_price, :quantity

      def initialize(response)
        @pid = response['pid']
        @lid = response['lid']
        @sku = response['sku']
        @name = response['name']
        @unit_price = response['unit_price']
        @quantity = response['quantity']
      end
    end
  end
end

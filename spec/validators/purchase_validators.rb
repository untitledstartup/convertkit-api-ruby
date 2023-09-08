module Validators
  module PurchaseValidators
    def validate_product(product, value)
      expect(product.pid).to eq(value['pid'])
      expect(product.lid).to eq(value['lid'])
      expect(product.sku).to eq(value['sku'])
      expect(product.name).to eq(value['name'])
      expect(product.unit_price).to eq(value['unit_price'])
      expect(product.quantity).to eq(value['quantity'])
    end

    def validate_products(products, values)
      products.each_with_index do |product, index|
        validate_product(product, values[index])
      end
    end

    def validate_purchase(purchase, value)
      expect(purchase.id).to eq(value['id'])
      expect(purchase.transaction_id).to eq(value['transaction_id'])
      expect(purchase.status).to eq(value['status'])
      expect(purchase.email).to eq(value['email_address'])
      expect(purchase.currency).to eq(value['currency'])
      expect(purchase.subtotal).to eq(value['subtotal'])
      expect(purchase.discount).to eq(value['discount'])
      expect(purchase.tax).to eq(value['tax'])
      expect(purchase.total).to eq(value['total'])

      validate_products(purchase.products, value['products'])
    end

    def validate_purchases(purchases_response, values)
      expect(purchases_response.total_purchases).to eq(values['total_purchases'])
      expect(purchases_response.page).to eq(values['page'])
      expect(purchases_response.total_pages).to eq(values['total_pages'])

      purchases_response.purchases.each_with_index do |purchase, index|
        validate_purchase(purchase, values['purchases'][index])
      end
    end
  end
end

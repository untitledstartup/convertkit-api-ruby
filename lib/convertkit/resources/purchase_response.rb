module ConvertKit
  module Resources
    class PurchaseResponse
      attr_accessor :id,
                    :transaction_id,
                    :status,
                    :email,
                    :currency,
                    :transaction_time,
                    :subtotal,
                    :discount,
                    :tax,
                    :total,
                    :products

      def initialize(response)
        @id = response['id']
        @transaction_id = response['transaction_id']
        @status = response['status']
        @email = response['email_address']
        @currency = response['currency']
        @subtotal = response['subtotal']
        @discount = response['discount']
        @tax = response['tax']
        @total = response['total']
        @transaction_time = ConvertKit::Utils.to_datetime(response['transaction_time'])

        @products = response['products'].map do |product|
          ProductResponse.new(product)
        end
      end
    end
  end
end

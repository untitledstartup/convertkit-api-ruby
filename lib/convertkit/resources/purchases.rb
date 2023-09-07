module ConvertKit
  module Resources
    class Purchases

      PATH = 'purchases'.freeze

      def initialize(client)
        @client = client
      end

      # Returns a list of purchases for the account
      # See https://developers.convertkit.com/v4_alpha.html?shell#get__alpha_purchases for details
      def list
        response = @client.get(PATH)

        PurchasesResponse.new(response)
      end

      # Returns a single purchase for the account
      # See https://developers.convertkit.com/v4_alpha.html?shell#get_alpha_purchases-id for details
      # @param [Integer] id The id of the purchase to retrieve
      def get(id)
        response = @client.get("#{PATH}/#{id}")

        PurchaseResponse.new(response)
      end

      # Creates a new purchase for the account
      # See https://developers.convertkit.com/v4_alpha.html?shell#post__alpha_purchases for details
      # @param [String] transaction_id The id of the transaction
      # @param [String] email The email address of the purchaser
      # @param [String] currency The 3 letter currency code of the purchase
      # @param [Integer] subtotal The subtotal of the purchase
      # @param [Integer] total The total of the purchase
      # @param [Array<Hash>] products An array of hashes containing product details
      # @option products [String] :pid The id of the product
      # @option products [String] :lid The unique line item identifier of the product
      # @option products [String] :sku The sku of the product
      # @option products [String] :name The name of the product
      # @option products [Integer] :unit_price The unit price of the product
      # @option products [Integer] :quantity The quantity of the product
      # @option products [String] :account The account of the product
      # @param [Hash] options
      # @option options [String] :first_name The first name of the purchaser
      # @option options [String] :integration The integration used for the purchase
      # @option options [String] :status The status of the purchase
      # @option options [Integer] :discount The discount applied to the purchase
      # @option options [Integer] :tax The tax applied to the purchase
      # @option options [String] :transaction_time The time of the transaction. Defaults to the current timestamp.
      # @option options [Integer] :shipping The shipping cost of the purchase
      # @option options [String] :subscriber Whether the purchaser is a subscriber
      def create(transaction_id, email, currency, subtotal, total, products= [], options= {})
        purchase_options = options.slice(*(%i[first_name integration status discount tax transaction_time shipping subscriber]))

        purchase = {
          transaction_id: transaction_id,
          email_address: email,
          currency: currency,
          subtotal: subtotal,
          total: total,
          products: products
        }.merge(purchase_options)

        request_params= {
          integration_key: options[:integration_key],
          access_token: options[:access_token],
          purchase: purchase
        }.compact

        response = @client.post(PATH, request_params)

        PurchaseResponse.new(response)
      end
    end
  end
end

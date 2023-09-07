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
    end
  end
end

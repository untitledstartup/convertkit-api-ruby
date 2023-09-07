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
    end
  end
end

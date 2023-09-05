module ConvertKit
  module Resources
    class Account
      PATH = 'account'.freeze

      def initialize(client)
        @client = client
      end

      def get_account
        response = @client.get(PATH)

        AccountResponse.new(response)
      end
    end

    class AccountResponse
      attr_accessor :name, :email

      def initialize(response)
        @name = response['account']['name']
        @email = response['account']['primary_email_address']
      end
    end
  end
end

module ConvertKit
  module Resources
    class CustomFields
      PATH = 'custom_fields'.freeze

      def initialize(client)
        @client = client
      end

      # Returns a list of custom fields for the account.
      # See https://developers.convertkit.com/#list-fields for details
      def list
        response = @client.get(PATH)

        response['custom_fields'].map do |custom_field|
          CustomFieldResponse.new(custom_field)
        end
      end
    end
  end
end

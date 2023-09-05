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

      # Creates a new custom field for the account. The label must be unique.
      # See https://developers.convertkit.com/#create-field for details.
      # @param [String, Array<String>] label The label(s) of the custom field(s) to create.
      def create(label)
        response = @client.post(PATH, label: label)

        if response.is_a? Array
          response.map do |custom_field|
            CustomFieldResponse.new(custom_field)
          end
        else
          CustomFieldResponse.new(response)
        end
      end

      # Updates a custom field label for the account
      # Warning: An update to a custom field will break all the liquid personalization tags in emails that reference it.
      # See https://developers.convertkit.com/#update-field for details
      # @param [Integer] id The id of the custom field to update
      # @param [String] label The new label for the custom field
      def update(id, label)
        response = @client.put("#{PATH}/#{id}", label: label)

        response.success?
      end
    end
  end
end

module ConvertKit
  module Resources
    class CustomFields
      PATH = 'custom_fields'.freeze

      def initialize(client)
        @client = client
      end
    end
  end
end

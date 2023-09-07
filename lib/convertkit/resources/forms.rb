module ConvertKit
  module Resources
    class Forms
      PATH = 'forms'.freeze

      def initialize(client)
        @client = client
      end

      # Returns a list of forms
      # See https://developers.convertkit.com/v4_alpha.html?shell#get__alpha_account for details
      def list
        response = @client.get(PATH)

        response['forms'].map do |form|
          ConvertKit::Resources::FormResponse.new(form)
        end
      end
    end
  end
end

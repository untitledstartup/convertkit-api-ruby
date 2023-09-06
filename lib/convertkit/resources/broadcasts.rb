module ConvertKit
  module Resources
    class Broadcasts
      PATH = 'broadcasts'.freeze

      def initialize(client)
        @client = client
      end
    end
  end
end

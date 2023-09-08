module ConvertKit
  module Resources
    class EventResponse
      attr_reader :name, :sequence_id

      def initialize(response)
        @name = response['name']
        @sequence_id = response['sequence_id']
      end
    end
  end
end

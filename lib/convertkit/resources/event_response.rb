module ConvertKit
  module Resources
    class EventResponse
      attr_reader :name, :sequence_id

      def initialize(values)
        @name = values['name']
        @sequence_id = values['sequence_id']
      end
    end
  end
end

module ConvertKit
  module Resources
    class SequenceResponse
      attr_accessor :id, :name, :created_at

      def initialize(response)
        @id = response['id']
        @name = response['name']
        @created_at = ConvertKit::Utils.to_datetime(response['created_at'])
      end
    end
  end
end

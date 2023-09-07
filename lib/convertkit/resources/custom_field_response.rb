module ConvertKit
  module Resources
    class CustomFieldResponse
      attr_accessor :id, :name, :key, :label

      def initialize(response)
        @id = response['id']
        @name = response['name']
        @key = response['key']
        @label = response['label']
      end
    end
  end
end
